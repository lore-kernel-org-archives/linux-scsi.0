Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57DAC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 23:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4624610FA
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 23:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbhDOXco (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 19:32:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36350 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbhDOXcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 19:32:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FNU5QP161716;
        Thu, 15 Apr 2021 23:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=t33na7VlfzflFtAaK24DayHVmvDa3uRJ1eRta3ndppU=;
 b=c2g5ntyTw0dLYTj6pY12OnrSfNCRvBxN4QyW2MldvwDWiwnbrTNAF17OYlczyppTw8C5
 xmhiovTsIkoAzrT0xKoJrNjadDC0PU5QasV6/Hmig6ho8xiIieuQ34zA/uIUp/GiIUeT
 kfQ+1Hkm5zumfXrpSaF6zbFfV6okuAVJedmAG1NIUfsXRKlMNoSGPocjp582u0q8Pyvi
 3vkGVMR7wK7dKa5bSyUX8pU8C9eUNW0Mc4YMgYj2enEnkzQNamMTYi7VcRB8RL3xZNhb
 wqKxAosOWi7A7Zq0pFMNf0qbTGNtPouViQJHKzExfvHv3pheLUYR399nmyDJq4yDQstP jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbqm3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 23:32:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FNUV84137519;
        Thu, 15 Apr 2021 23:32:13 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by userp3030.oracle.com with ESMTP id 37uny1r9n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 23:32:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAPOg1Qbd3twy3syMMUAvOdqcSlLzRazuj1XBRo1zM7R2tbY5Lq4L/5y/qI4gWxB9BFI8jgutEL30tXr74qRuiA25ERDLKWTYmZjm/unINtJbxp9n+2eaC6YJRDxxMDXjtuVCZfbTOvj7qKZJZK0YU6sfhXwDTi7wC2Mtxa24mcG9diFRKyiKhfERBcSgfQprTuAWxBOvlfDHDYtXhc3Q4OYvETS36wADqt4SC/2VECvqmG3fbFHIjiO2AZT+HsQAX6uoMmtkDw3LadxH6LXlIltERIo+IxULPq9Ext0QW7+6rDrAknqn9OVGXHbmKb+Q+d/j7wVhRBSVNORHIlolw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t33na7VlfzflFtAaK24DayHVmvDa3uRJ1eRta3ndppU=;
 b=m3iLXoIXcgguTsgOISU25CuACaqwqAQHye0pSB0ogaOagIwOVmDBRcC99GmI7tbaHMc1AIsO3ru8tn5wfJlkTH/iZUljqbIus88Gc7gx1lh41pPHJmgDivHMz1+NiNQjGFf0jgOS7rOAZFJkWFYECJTIxhlJlL3K54lCPNUErg3N1wh//QtqSMzKY67ESMKtM3Ze6Xo8xvzWjHwpUTuv8crwKuZtIasQmBc2azwxSJXebY7DDUCIFvIn+AFMsBiOU04Svqu3z6gASQS9xHptKR6/uQgE/2a3SBIyohPIezpDgl/kZIDXsJgJjy/1hP270x+Hyjd3M5M6MX/UYcGHZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t33na7VlfzflFtAaK24DayHVmvDa3uRJ1eRta3ndppU=;
 b=v+1iIgWS1GdlDYDCdTIQEw+8kk8cYV4s5EhR/Jaqv0huupt6iUA3HfegkfcLbGQ2M1dvbIPZASAvQj0cC62iPUPLrpDAhapnhdYUfPYLYSGj1+9+SRei5044j42o7ZRcgWjnUJwlh2TN56uMVJ7jIX3XzOCZFd3VYu8I9DO8VqQ=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB4057.namprd10.prod.outlook.com (2603:10b6:5:1d4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Thu, 15 Apr
 2021 23:32:09 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5dea:9ca5:fde6:537f]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5dea:9ca5:fde6:537f%3]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 23:32:09 +0000
Subject: Re: [PATCH v2 19/20] target: Shorten ALUA error messages
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210415220826.29438-1-bvanassche@acm.org>
 <20210415220826.29438-20-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <0724ed09-c034-8246-6d6a-0b41924cf0e0@oracle.com>
Date:   Thu, 15 Apr 2021 18:32:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210415220826.29438-20-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:3:115::24) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR11CA0014.namprd11.prod.outlook.com (2603:10b6:3:115::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 23:32:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07a8eeac-796c-4db3-0be0-08d90066b055
X-MS-TrafficTypeDiagnostic: DM6PR10MB4057:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB4057AEFC3D3DC0B95D3ED185F14D9@DM6PR10MB4057.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xLmccO3w2sNbGrZoYvZ/FcHLJuh0Ugc79niA/3s1j1nsD8W+bMaNI5gQw3lcC68NpeUIqZ9RUst3LYbpqk2tkW6c24nhWktV2jhDeCpJ2OgVItlS7opGJ881Nb6OIaIYAlNQOI6yhQd64pfi789UF/auh2JKxBmrZ+hjqLEPhPWVftgiSQkJUEB0wcmtMeEtbUWzbn1roz/90QBe/NSVnO4i+jwLiGe4++gTfnphDt3S/W091I4kyHGAvBIH3LtOr2WCEoPhRV/yt1rudoDCMK6AVFQBxkt672pt588LpLPquxWunXXhDh5j51v3R1vCOJ/+cxETXggF8KlYnTsq4w839BVl3hoaVCxlAjgUPZ83fIwND8/2iIJOaDX2SEqvRKGnGZJHbqO5sIReCbf7gDASTq8JCnQz9QELp2NSpikcIMyb4+ndipNV8pPGc1P3Kq8pT7AGDqbcNM3bKdAshXbUcdaYAumrO+JzfMlSLHZEMzG4sIZ/ELplbJS9Zh83Gb7Xn1biFhXcYEFtdGEXcb15GKiKrX5uKuv4gDrwV4Hwp16dF8uvQGekPpLL5ojxySdhZe1mCWxzEkNNshkfcnug1B+0e9wNyPdrO/W3byZO0P6eqCCbbSYvWg4H3B8KPhvfsQRtewYxR4KAleGGbrVIea3IFdRoQOYI9VzID83QHaGEiwlmgKQv9b2m7FnLS+29iWUsC0RA60/I82JONw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(26005)(86362001)(31686004)(316002)(2616005)(31696002)(5660300002)(110136005)(4326008)(8676002)(6706004)(956004)(38100700002)(16576012)(6486002)(508600001)(53546011)(8936002)(66556008)(66946007)(2906002)(16526019)(186003)(36756003)(558084003)(66476007)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dmR1VnNOaUVJaEFTSm5nbFhyb2tqSWJ6OFRObTg0Qkh0MWlTRXB6a2NiTEhw?=
 =?utf-8?B?THc1Z1RGUlNqNmJPMTlCRmxQTkJMUmhyai8wSmR6OE5DUkgrdWgxNnQ1OSsy?=
 =?utf-8?B?YUlNZEt2ODRqL3BoZVlwVThIbkVBQm94ZkJnVXdXcTBpS25QdnhzMlFBNWti?=
 =?utf-8?B?RnBGMWdGSERUV0pWQTgxSHYwTkI2MGxDeTZTZzU2TVpvQmNhbm5TMEw2WFJq?=
 =?utf-8?B?ZitMR0J1Y1NlVnQxc0svanNKUTRSRVJiaFF0M3RuM3NMS3Y0dkNDRWxPa1dE?=
 =?utf-8?B?V1ZNdU52ZllEcnFjcXMydXo2dWduOEtjQ3MwTVpHQXNPM1M3a3REYy9MalQ3?=
 =?utf-8?B?b2Nzd2xqYmFwcDR2a1lkNnVRS29Yd3hwUmd4RGxUK1NuOGQxZzVLMHJtTllY?=
 =?utf-8?B?OVdzVUxUdGhIcTFaV0JSTXA5UDFqM3cyZ3drZllwbEFjbGxESldCeXZHb0J1?=
 =?utf-8?B?aWd6OE16K1I5eHFPanhiR1U5MThhbzNWdm9nQUVoakJwMFMyRURlYkRDTm1Q?=
 =?utf-8?B?d0liN2cweHEvZXQzMXV1M3ZtenBkbW56emlFdmhqL0luUnF0ZnNZOTZIK2JN?=
 =?utf-8?B?eFFCN0Z2QUJlQXpPN1haYXdiZE9MSlNkL2JwUHk5WExzcUVXTkU4cWJCclN5?=
 =?utf-8?B?WUpMTGZNajVRNC92YVRabnM2U1BnQ242ZDRLM3Q1MmUzREZCblYxYmhvUjNU?=
 =?utf-8?B?Yy80a1hvUVIyd2NMRHhRMXZoMFczSXR6OXMyTkJYamZpL3dhOFVMckNVMjFk?=
 =?utf-8?B?NUoyRlJNdHJScS9mKzlQWWtqQVRVZ21FeERHZlZjdnV5K0pjWGt0Q1MyTm9t?=
 =?utf-8?B?eW1VTGFDRnA2N25hTzA0VUVYWHozWm9aamRVWmx5emJEVmdhbmNITXgrdGsr?=
 =?utf-8?B?RHMwRGNHakt4Q0lvczRXUFVrR21jRVoxTGFvZUtTY2JmbUhoRUZmVUVIeGdG?=
 =?utf-8?B?aXJmM2Fscng5SnZPckg3ZzQ5eHY2a3EzbzUzQTFDQmFnQmZYampnZWUxTTFw?=
 =?utf-8?B?UUo0enlsT0pFRkV5M1JCUnY2c0Z4ZlUwWGZrUWhXd1YyVWQ2eXdpYjNGbllL?=
 =?utf-8?B?eTAzN3AvTGpxSkxRbzlhcjA2YVZOVW5qYjdnYlpzYk1BaTRtRzNOR01aNVpl?=
 =?utf-8?B?NjIwUmtYS2lpNEVsV2JBS21mK21iTUxwRWN1aVZMZmtLb0NmUkcwYUZlSXlX?=
 =?utf-8?B?czVMZ3NSdHdMVlpqUlo4SFR1NVhuZTJuRXc1NGFvVVkzYmREVFVmdjRnY0lG?=
 =?utf-8?B?UmhuaHRpUDBCK3RudkFSdHkxSVJwNk94S3djOUFFZ2lvNFZtS0VNRDFyTk11?=
 =?utf-8?B?aEJzTVRNaEtGQldXQ1Y2bkEranFHTWpWcjc5SXg2U2Y3L1FaOHRRMGYzY0E5?=
 =?utf-8?B?OHVEODUwcU16MTR3V0hRRkR3ZHNGNFB0ZFNSOER6YVJGMk1RaHZQNFd0clIy?=
 =?utf-8?B?cTlnRUQ0c0JDb3RmV0IzeXJ3bCtYZXdrQzFBSWtEK29NclMrall4Z3JzQzQ3?=
 =?utf-8?B?RzFOaGs0enN3Z0cxWlpnRnM0eG9Ta0tKN1pUUGtKbGJDVWNHYTlWNmtYNUlN?=
 =?utf-8?B?NERwSkhtWHlURmtzTTNETnFicHJTcGVvQnNMVDEzTmFLZUVDRlFPR1g0YXl4?=
 =?utf-8?B?dWZsdVVqRHp5R05RelVpZWVHTFdNa1RqSzhZcVJDbWYySk0zQ0N4SjluNjhS?=
 =?utf-8?B?L3lwZjI1anZGaVhhaU4wOWllemM2WGp4Y2lZdk40dy9vYkozc0lwWlBzbkN2?=
 =?utf-8?Q?DFxYlW480nIbniFkoEdVhgLTC8GHD4lmdOefHkf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a8eeac-796c-4db3-0be0-08d90066b055
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 23:32:09.8401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ziU6ta3J3gzH2QVqD/Y2CxoXvbXXcxgAte/XBbVJp/oAkcadPIQuyqF8g4gsTJkUUr+oFq0bIn0itIN+4OvDc0YYWapfVgFsXKkh8XBq+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4057
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150146
X-Proofpoint-GUID: go58n41JsSjsSfFsGefLthROl6pc7w8o
X-Proofpoint-ORIG-GUID: go58n41JsSjsSfFsGefLthROl6pc7w8o
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 5:08 PM, Bart Van Assche wrote:
> Do not print tg_pt_gp->tg_pt_gp_valid_id if we already know that it is zero.
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org

Looks ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
