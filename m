Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C575BC43217
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 23:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiI2X5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 19:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiI2X5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 19:57:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D9EDD355;
        Thu, 29 Sep 2022 16:57:10 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TMihke005145;
        Thu, 29 Sep 2022 23:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l9QhhITwIpmPOSBmjUIZrcyQT4EM+tL0qqvNUodpXJw=;
 b=BUwN/u1jmDMCAgQnYA6PeA4RmDlpG1vaYqytQdXlwvJF1D2+do0JRpOLa1/WgdYyr+H7
 QZgPOHt9kOStSFcc7+1htlDSGrHi15n4x+U+syl81C9mvU5KM+UmdWV+uwqHEWRvccFw
 wY9O37vuLSjGc9zunsZucyhEI32P13kWHnyy2KOgAMysSpbpeK+Jfqqi4AU21BsTpwDt
 0Bfhq0mQUmuOHLVCHNvDECofOX2myONuySAcd8+/XbBpFn2iAqMyDUib7U0nAFHVoILr
 CPXNhcCdImt98eXqK5r53Rt8jGCn/cDYG/CDEaNKuPTtdmsNacKqOaHVNMfiVDrSSYQc Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet6uxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 23:57:09 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TKsM9G040308;
        Thu, 29 Sep 2022 23:57:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpucq505-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 23:57:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aV8PH+zxn8PjPywrR0iFx06fafLqjVa6LSIfrR64M4UQaZJAOCqRpHy1edTg0vUcZss0RbnF57o1wp7/Ju9U7AVfWvUlf+rDrywZaYFsTrvWLl6wPR5+DedAFok2GzspFYoHgkPJgfHSyiQ2x0PcxBZSrTVooCtdlDmatec37xwt/uzNs2Ll85L3ry7fXsEqJiwsUysC3Gyg6fiYO3JKgFcNl69NHhTiJTUXDP5se6RHM4FEdYz1V2M92gYB5bLm9q5QW2eUkLi5oqRXdWmnMhTXSUutXSULBG3mYQrG6TN/JRmZY4xyN4QRH6WqlqdfwAg7DzYoKylPlI2aSMsQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9QhhITwIpmPOSBmjUIZrcyQT4EM+tL0qqvNUodpXJw=;
 b=mq3PGIWRvYpdCZn3uCnU7kvWK3OIAyWcabARMFj+J7bjlSkKtNOoozwl0tZDIUnATSpQEwWttFL/1vPR2xHK9SvjSgMC6vc6b3HuJJjsLCUBNgtV3GVu3FDUQkLqYAesGFSKj+Z7w4s9Dpb5deu/bKUrmLXrtsPK7Wr7Y8R4Sn4SGJvR733Ml2GJB3hORRb7EPR8+G3zF4T51371+3Mn+1Pi5WnJ0LyeOOq+DjQcQSox/IjL9c3mXJa4Z5iq6q58SF8BkhDvG1gqKONmaXVqKD4RqGtS7pSLd+wWOkix4VVg5X7gMwKUygIcjhfsRXpCD6jzko7l5V8pPWGwRrJdZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9QhhITwIpmPOSBmjUIZrcyQT4EM+tL0qqvNUodpXJw=;
 b=SAHTZp/OlxVTGstwj4xZq0XgY3PtWHoTlgF//c9mnJPZxA13Arvd+m9+h8MjCTLtFCKBwLKHt1OuIyStRJ2ugSt0kQ80gXITW3rsKQLFs21Ez512K9DmRgp9mu4lBbIeCOmhuw6USqxJYGaRNQJslieqsip4GgHm8mL0lRC0U0U=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6326.namprd10.prod.outlook.com (2603:10b6:a03:44c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.26; Thu, 29 Sep 2022 23:57:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.023; Thu, 29 Sep 2022
 23:57:05 +0000
Message-ID: <056b4919-e1c1-55f7-3fdb-74053ae9909e@oracle.com>
Date:   Thu, 29 Sep 2022 18:57:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 2/7] scsi: target: core: Add RTPI field to target port
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-3-d.bogdanov@yadro.com>
 <6f4dba25-33af-b268-bf6f-541febf3c939@oracle.com>
In-Reply-To: <6f4dba25-33af-b268-bf6f-541febf3c939@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0011.namprd18.prod.outlook.com
 (2603:10b6:610:4f::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ca99627-6bac-4a73-64e3-08daa2764f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q3c6DH9G5ToisDeg0AQ5T0zHTbjh1lD1+NNY9x3o7KzkhflQ7UnyRHPiAyZPHWIVymzSh7zE6vbnPDFb/i1lXue0Fl5nxsdRByo70GeRiB4HpGXKHvnhRewLnM8vrakbL2om6JmE98xiWue2fHZQGxcsSDNtGyTbxJ8TLt5rG/GGasd131jqeY9sJcSSke6PE2N2lIvawD0sdIxWEfydn6pzWxSp+TuHqvCDfX4l/YkB6zHgttESVZOlGu6Dw93nwji6tT8F8D42eNxp91DQCfvLTK5Tg7QtF0hqWeDIgjS/qkxbsDusNx7W0dOGmn+SPGZffpFId7onuvL4L1HJuusgCwCsXUHCLzGBr9NaO/yp3U6+a3f92irKE6jz7anr2uD2dtlV3CwpaBgFoX3v01zk/i/w12w/fsuDaCqEzbRlHF6CxgLE1J6OWyZB3cOGs0gmNilEDk8Tg/aGstmtwqrwZJdpecUJmxxBKd5tekuvFWEoJdXhlvnhSBYcPiNptcS+lqmxAU6lKXPbN6qQmJxZEJTVlqzKKcWoIoE1G0zW0XFacW01qxiRm8I4IRcyb07rqk0qO0/R0/GF6v6/IuGAE1kFeVg2txiHqPW33Bs2ig2bML4XYLmn9SqWsgqQbxSMXpygiPYlWe6AMSgu0bQowcL5eOp89zGEjy78QQ6Uf+IZdSuGrUNS58/H2TjutsQS8++ZBqHo62vUH5JCm4uL+flCp+Uld+L1yIMG+lbZeSEOcz5sVZiOLpeYF7qsnXK6K2aNah670WA+tt2C7hDS4GYUY9LMMruNjpjZH5E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(31686004)(558084003)(36756003)(6486002)(53546011)(478600001)(8936002)(2906002)(6506007)(5660300002)(31696002)(186003)(316002)(66946007)(66476007)(6512007)(66556008)(26005)(86362001)(2616005)(4326008)(110136005)(38100700002)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UC9VUU1oWUd4dTBTaG9lZkVLenErMTBnUkpIdDRCMmUxckthS2x6VUc4Ukc3?=
 =?utf-8?B?UnBaeUFUZC80UDJKQUJMVXB2VlhSUFVrTEZuTmhpdGtWZUw3dGlhckw4cHl4?=
 =?utf-8?B?cEg5M0lWVnpnTzdiZ2I4TWFFYmh3ek1GOEMxbXY3dkx4UXMxNjMySG11R2lR?=
 =?utf-8?B?dDU1aWVLeVFJUXJNM01OcGhLNGZFZUwzcGNHcUs1SVNvSkJCc1RScENMUVJi?=
 =?utf-8?B?UG53a1VUUlI5b3ROQUtYV2o0eDNJWnpYaWoxbWVpazEvR1AvTXArS0Z0aEk2?=
 =?utf-8?B?OUZ0TFlLazNBblZqMTZiQ2J2aHVWVkxwbTlmZmVhSmVJWDVZZHpJQVM5TjQ5?=
 =?utf-8?B?MTBUZTZnL3JzOGU4bllQeEZTSWVpam5vWUJIZTlmbUsya0N2TzZCODVOUXZo?=
 =?utf-8?B?YVRTbFJCV25TSEVWc2l0VkpMTXhoSHd4clZMMmxQWlp4ODBNUmhGWG9USTl6?=
 =?utf-8?B?Zk1YV3kxNzRkZlBrOWZxYUY5bmFzOWRmeVI1eVJsQWtvczd1d3puWTU1N2ZV?=
 =?utf-8?B?UGV2UzBJa2ZTVnJEcjNkVkkxL2xubXhhSW5VTUttUEthbExIbVhMdXhlV3p4?=
 =?utf-8?B?NUt5blNFUlh3bmp4WkpWTExqZWVSMjZ3VkxMQkRLdVc4eDZzRS9JMjg3Wkpy?=
 =?utf-8?B?TmxWUXgzcHpzL2tIMXJmbVgxN1EzRElRbk0zQklWSXVnV0dEWjRDQTBpTSsy?=
 =?utf-8?B?cys2RWJSMkhTcGRLdFN4cnZHTHVwMHlGTmFpZ0N3UDNyOWc4a2hQeTlkTEpk?=
 =?utf-8?B?T1VmN0ZMWWdEWlJWTHEvN091ai90NTdZRkRGdmlEdDVxaFBRV0t2c0E2NkhR?=
 =?utf-8?B?MW4zUjkxTWhwcnJlQjhONWFBQXlXMUt5S0RpSGxvUGkyL2Z5NGNpYy9wWnha?=
 =?utf-8?B?bU51cDZUSGVJYThqRW4wc3h6bVZtY2trU2VmU1dwZ2Ivbyt6citrYmVlN0FL?=
 =?utf-8?B?YkU2M21LTytsN09vam10aEdyTUZmWmt4UnM1QTJMY2M2YWV3bG8xZmUwajJL?=
 =?utf-8?B?Vlg3V2xzVTY5ajJxdEtTTXFNbTlIb0VCS1ZHTkFpN0NxSFBObzl4T0NJa21a?=
 =?utf-8?B?Wjc2RDl1NWU4dU5JVlVVT2kxSmhrM2w0RGZ3dzFIUXZJNUZ6aXlDdE9SRXp0?=
 =?utf-8?B?aFZFR0c3U01aRUs1QlNXdVRmRjg3SEx2OUZwbTZRKzBHa3ZEM0RhSVJHS0FE?=
 =?utf-8?B?THB0M043Ri9pSW9UVTZmSHF4YmRkR09FSXJMRHQ5TjdsazlIaTZwYW05R3dH?=
 =?utf-8?B?VnNLanFndlhZTUcxOVRzcHRFVkJFdTBYWkdlSmJmZ1hqcWZqOWpBdjlMd1Nz?=
 =?utf-8?B?aUE0d0gvSFFNQTBSOHJzaTIyZmlxR2ZRWVpUZDR1Sm1uNlM4YWp1eHUvQXlS?=
 =?utf-8?B?dXJyc3F6RVIwaUxzZDhoei9KcW9ZajRYaUJrZ2hNZzVacE5lelVHOXRuN1Jr?=
 =?utf-8?B?eUdTRzM0UlRQb2JYNnNZdXFlVGZGdnliZnV5RXp6Um5wckkvNVZqbFQxMk51?=
 =?utf-8?B?dS9VWHhiVHVRRHZqNFpPQ256UThBaDN4TE9paDJxMW9QUGlRdnJqeXduNXc0?=
 =?utf-8?B?T3ljSVY5eS9qRVdtTFlSM2tKUjdjZVdLbHBUZFhTTmhZYjh5S2ErNlozNHdz?=
 =?utf-8?B?ZmpIcVBQUzcwVzN1L1VIY1cvandMUkk0OWtlWERyNzlZQjNuMWVNU1FpNmt6?=
 =?utf-8?B?c0IyZUpvZU92NlkxNzkxSFZ1TEppVjdabzJXeC91cGlJUUFtYkU5UUE5empI?=
 =?utf-8?B?YVVTdmNpU3ZFb2l4Zy9zT3VWUURzN05lT1gwK29GU3lmZnpVTUwzOFBQdkhk?=
 =?utf-8?B?NmFNSWorc1FZeks5cjFpc0pxRmNaSXBhNXpWMXZKc29sRzhJdjM4NWFnQzJx?=
 =?utf-8?B?Zlo2QVFaaUs5QTJEMEVrVXBnTGZhMWZBUjROYVUxNURFM3NXQmlJSHljNzE1?=
 =?utf-8?B?R1ZBbWUzSElTYWhUODBlMUNmeDVjVGJqUFRYY0JSYWVqRnhScDlOcVo2QkRD?=
 =?utf-8?B?QmhDMEtkKzdQU2xsZml4R1YzcVB6YnlITENpYWd0K0lvN0RURjE0U1cyc1lj?=
 =?utf-8?B?aHh2dnBBdkRMUHFvRVdtUGZjWFMxekZxbWhtVVFlL3B2QXhDMllUMndFY2Zh?=
 =?utf-8?B?L3RvSmx0RUk1K0NkUjJGNWRyZFp4YWJIaDIvMzJyVG5rOW9ZZmJYbTdSWGFS?=
 =?utf-8?B?NEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca99627-6bac-4a73-64e3-08daa2764f70
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 23:57:05.0827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KhLbxr+AEv6HE5DHG9dsRsfZJdUYXFmNd03WfEtJEIOd3/g32GajHT5cjtTLDXY/SJ2Rj7Zy3CI/oAYTW/DkgtYBH8PawTnbyqnlwBYiKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6326
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_13,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290148
X-Proofpoint-GUID: QxWsCPcmw9P1Rw042Y99V4pE84CpAqw1
X-Proofpoint-ORIG-GUID: QxWsCPcmw9P1Rw042Y99V4pE84CpAqw1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 5:26 PM, Mike Christie wrote:
> 
> I think you could just use an ida.
>

After seeing the other patches I guess you need a idr.

