Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2A6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 16:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A719260F35
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 16:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhJKQwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 12:52:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41632 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhJKQwV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 12:52:21 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BGftKZ008792;
        Mon, 11 Oct 2021 16:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qEsMKswF51Wmbo4S2YEwzKNlORB5BvD9s/FEJWwLbMw=;
 b=W2fasWkBfOWKdnFcCd7Ndh9tofpyPH+5JmERvktw3UMAlANUYTnXCaOqjVjbOCP3bR3k
 /WbGZRjOCL/i/vkSbb5TQLldgxTMJXZgu6XOXOePKmZwkQjrMdh9IKdObfOOeRpbd6tq
 806etG+26vGczJevO/qxwutpqDHRoma/KnxF40WmUCBBUbyfqu0Ve0IkVbZcPr4Xgl/D
 5weE23iDFIau4RVtEdl4Egpko0qqF2YIDYQj8/nsBH98z7rg7ER/rbQ7HjVZn32drzTk
 CxgIP4IZ1APOHXq6tmUZLKfWEov9G3vfY+escH+kwTZMTzPs6kAuEVrbzBEug+G5B8DU IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bkxs5dpju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 16:50:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BGf25m106583;
        Mon, 11 Oct 2021 16:50:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3bkyv7b7tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 16:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2j+oL4DZO0M9IR/SXI0vjV3jbwPlVV4Nc41hiATSfVh0XFZuRYPiZau8orQ5oUggEq4ztuJwYdtAIiazfZQjXfjPEeUFZvobJ9096It558v2gYRBYF5NV20hhfXDGXnRmy3hIuGgjCml1FrbqxTmYYyOeAgWt62//6ue1QHjZep6SRppIg5+/lTHrx9b7pabyx26KMKMiWEcSKiiAClNRaI+/+g5yaGAKffVzAg6gIze0NqXxj06jdcQhGfM3Of3up49bhYrh15Q062Ad1YbJ99WeDSiJe8VxwM4waOnzzshUSCLalUYExxjtj4EZh6dEIk7dD4/Bwt20cfhNbFdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEsMKswF51Wmbo4S2YEwzKNlORB5BvD9s/FEJWwLbMw=;
 b=KAS6pQoInmUHfdS5dF8W2dbd8cMm7l1GTOOTupSF64R9FXwxHyMbKtYWTR9ff/fM9IMFzEgS3XXsuAcQTflUpm8WBmKsUXuxuWVXVRpVSWBH40bq6blt2PC6Q6f/+BWaIdxeYt7ireqlzc2en6OibHpROCWgGsHgMnaF/UnItL2wMZlP4W1aL0nM0iobxduT9DklcB1sq6xDifCgg/MzHkhCFkgMUQkXtEdXF2mXk4ZnzPKqGfN3EDBoqS9phvsfYhqwkmlF0WS0Ot4ex7YLQNtrUkPyZkqK/121IhYwEBknpfHYjhSIPnPb5Ea6yseqcQ2U3atHvXJgFTI5pKf3YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEsMKswF51Wmbo4S2YEwzKNlORB5BvD9s/FEJWwLbMw=;
 b=bFEX4Z1ZJgkiAFbQ/1kOQw72wiIADCZnaIOH3/j+367cygGfxSoyZ4vcJqP9H20xN0RRp9N6G8bqhoT983kARLMoaZcNQ5ylnWRVpm9l3sqYYSoQfvB/2QGVgvEa9Ne2vz/Hgo0wRgsuws/IhzfnILBLKE0G8hkvM1tFfo1N1yU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1961.namprd10.prod.outlook.com (2603:10b6:3:114::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Mon, 11 Oct 2021 16:50:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 16:50:14 +0000
Message-ID: <c9f869c7-9e83-6485-e256-f9e6886eb01b@oracle.com>
Date:   Mon, 11 Oct 2021 11:50:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] target: allow setting dbroot as a module parameter
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     bostroesser@gmail.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210927193814.79111-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20210927193814.79111-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0014.namprd03.prod.outlook.com (2603:10b6:5:3b8::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 16:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9deb638d-f90b-4640-7f55-08d98cd732a4
X-MS-TrafficTypeDiagnostic: DM5PR10MB1961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR10MB19611B5BC0188EBC8FDD16C5F1B59@DM5PR10MB1961.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtgMyujPuhUiP365JyIyWyon0+Bz+YLl2KOh2f77Q2XcdUzjlUqDPnYIzUrNtT7m59qJyJiYbWq3ID/IOodZD6UogYSAbMwvyhOf+PS2aCtGsMkoa796yJ2APj79oM47qdMmGNwIcga7KGbnMbZKKhsGySnPogBC52UlQZyqmLxkP3buPt/NH095U0D8FElB7U9kWyoQrev8jq0MgkIG6YFvDFZviWvzAb6fy3jTREgmsNhBKxO2rdY9H13XRfLYdndBnleFwuZDdtLBrqEidFJTIMKe7rzrNHhNpNKTClExvNcbB800GeZzJob+yds0ilAHUa3N8MQASMKjko+lm8udgn9XY34bgpj9oeWFzhPmmEBNitxn1ooo+cTnyu0qH6eI4jnvjI5ONrzh2FqfWtxKV6Va+igmxy7Ft+C6PUmBTCGPUpOFUawgNAEhv+Rr16990va2vy767CJITwEP27qjsa1tcTcoigDvVwdOXuECemmsqtjX76qNRhC9bQ11MzkXRjE3ueZyCQacTgjEkNFJJaxL70eaBNG75GWdeHKh61UakbbDc3CXqkeYdfBEnmjB8ghofSEsEXLo8MiEKVY7FT4pNvocxTSHHr3zSOjtlYGaoz6G8/g/BQjZ+UleVhebEW6KUXshMQ7uDHm52+0jocofZOSvD+3/JMeOPQzkJANnneUPgzwtjdQWYuYPR4OOWIzZ4nHQl2Y9qBTl/EZuqrmb/BNtJ9zPBCzssZdllZkIbTF60MPcBs9Hf6lKfkHkTGAR9Ayll4uXyl4ZHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(6706004)(6486002)(6636002)(186003)(4744005)(508600001)(8676002)(53546011)(316002)(16576012)(38100700002)(26005)(5660300002)(8936002)(2906002)(31696002)(86362001)(31686004)(66556008)(66476007)(66946007)(36756003)(2616005)(956004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXEzeHdhOEoyWER1aUViTm9uaHdXYTdkdjdxZGU5VWthY3IwazA2SGMyWUd6?=
 =?utf-8?B?ZnpqZWdZTXlWbnVpUUhOR1lKdmpwN1pXbWNBRU1YZnRiUW4rbllya0ZjTnJJ?=
 =?utf-8?B?Q0llaXpmWklHYWE1MlF3VlNTUnFuNXUzNGZwcWtwR3pGY3RXOWZtWHdremhr?=
 =?utf-8?B?T2ZnZjdnNUFNQ1pIRExaWit5Z1VWeXFHay9kY0ZDK3NGN25XaVR0bzBGQ052?=
 =?utf-8?B?WTh5ZEpDbnhRNHVIWWtIUUJZQ1lpRzNNL0tLVElUM0xkTlExdUlWVmhNRHdt?=
 =?utf-8?B?bXpuN1BZZ016TGlJV2o3THh4eUgzbENacWszcGU2NzhVOG5IbFhrOSs0ak96?=
 =?utf-8?B?RVpXdG16UUw5a0pBUUo4QWg2ZE1RRkVQUlVORXEvL1ZBYWo5dVhyL0RRdFNI?=
 =?utf-8?B?c2c2dTgzKzJmTHVTNmFTSk9MQnJnS0I2Z25YMU1Da0t0S0xwbUtZSDhvWVd1?=
 =?utf-8?B?T0xLYmxBTktOb2cvbUU5cFBya0FnQldvNzVVUkl2Y3BRcmJhN1VaamVPeVRF?=
 =?utf-8?B?VTk0cEpFR2tjSXo3WjhycGdoV25QODFDMFdRSU5pWGw1M1BwaHljTFdhQmtk?=
 =?utf-8?B?bTljN2YyRUlLT3I4TUlFak5KRmNQZ1ZFWVVMRlBiRVgyTXVpUXdMNUxUQktt?=
 =?utf-8?B?Q0NUa2NTWHFuL21uZ2oyWGlITExZTWw1UG5aMWNIRWlmL2lGTWw1ZGRteXdx?=
 =?utf-8?B?OU1pM0VBWEFhT1g0UzVDbHRsbHBWY2JtQTRHZG4wSFhVV2JGZzJvbTFNSmI4?=
 =?utf-8?B?MEk5NldhMWM1bmdmUWkrdGViY1NKa1NqL2dmRzZTeGk5YUIzMjUzTzlSbEtV?=
 =?utf-8?B?YnVIZGZncFRDVzBvcms0eTltWDk1WGxVVGcyREFZOTUrdjlmK2VMZ3JjdGl6?=
 =?utf-8?B?WkJnbThQS3JFeWRsckl6WmdxeUYyYlZOZmthTmZabDJkNVptOUVxQlVPM3cx?=
 =?utf-8?B?d1ZiSy9EcDZkMCthMlJ0a29LK0E0MmZYZnRWY2RkSkZtdGk3NW12UWFTbTFS?=
 =?utf-8?B?TVhXQUZWL1QrNHVHTW5Ib1N6UWpTRUluOHFGeU1rcm16NWtJbVVnNDZ6RFFK?=
 =?utf-8?B?S3ZPK1Fjay81QVhFQ3h4SjlGcjhGclJxRU11ekNYOGtzQnBuUmRaSkpzNXQz?=
 =?utf-8?B?MUlKZmx0VGUwT09tQmxxRHZ4SGVuUUZqeGlIamNBZ3FYWTVIVVc2bnk0aFF3?=
 =?utf-8?B?QXlUNXBtaG53aGJBd1hxQ1NSaEpreXlZcUltK3ZlQzYyd1hNV2l1SFp1d0ZD?=
 =?utf-8?B?L244djgvZExjSmZMbHQ3SzhjTkZ6eUdqM2RBUkJ2OUhIZjJsSTJyMCtRMFFF?=
 =?utf-8?B?bC8wTlg4TnN6dU5qZjNQVS8xQlBSdE1vUTNycjRpZU5KSno5UTVKRm5LdVV2?=
 =?utf-8?B?TmtZV1dRWTNLK0VjS1JFaUFhTnBMSUgxcUcxNno5L2hpNWI1UTY0NEM2Zkp5?=
 =?utf-8?B?THhZNGdwR0hYbVVGOC9QbU96a3RUaHkyQmU1N0xwYkV2bzQ4OVJYVGNWdEZS?=
 =?utf-8?B?S2VCblBCUnEybnNHcmQ2R3lTcXhsdHJqVEpHSmh3b3ZYSTNSazFycFhuSG1s?=
 =?utf-8?B?SlRTR0RPV0VZU2U4Z3dHd21HVnFKRzVWSldiQXFrbkV5MDhyaTNrUGpMbEZq?=
 =?utf-8?B?NUQ3OXdkd1BPdVZocDdkUEZuTEFjb0xWNE4ycmp4VW52TnYvUGFaTUh4M0Zq?=
 =?utf-8?B?ZmwvMS9mcFBXL2hPOGduNW8vQzZxbjJMRjZlQW5ya3lOVEpnU210ZGRITEJv?=
 =?utf-8?Q?VQLXLbz3JYeH7B4JUV9KRNqdfX4+glvw3GV2WEy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9deb638d-f90b-4640-7f55-08d98cd732a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 16:50:14.6363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbKlEiDNUAEZUBRf7AR1SQO94psuCEo3ELUI7CGqvl+EbCcuJbIOWTHTOFGeallUkngKCU17+Ut77W1QwrDMvOZX/x2ZvfsmnlNQ0P0jt1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1961
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=951
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110098
X-Proofpoint-GUID: hJUhCsuz-UabBzFgKMsX41EZQIgIOVLR
X-Proofpoint-ORIG-GUID: hJUhCsuz-UabBzFgKMsX41EZQIgIOVLR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/21 2:38 PM, Maurizio Lombardi wrote:
> The target driver prevents the users from changing
> the database root directory if a target module like ib_srpt
> has already been loaded during boot.

Why is that not allowed if we have a fabric driver loaded?

It looks like we don't start using the db_root until we have created
a device (alua and pr metadata), so you could add a:

static bool target_device_created;

target_core_make_subdev()
{
	....

	target_device_created = true;
}


target_core_item_dbroot_store()
{
	if (target_device_created)
		return -EINVAL
....
