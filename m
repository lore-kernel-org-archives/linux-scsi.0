Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263C2C4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 18:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiL2S4C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 13:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbiL2S4A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 13:56:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19013F91
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 10:55:58 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIrsbC004132;
        Thu, 29 Dec 2022 18:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=y0oFrU6R07mH0dWvS6iGlkUbcFeTo4SmA7iA98Ej/y8=;
 b=fPADDP8huQGlAmWOcdaVOTspqQixvaj3kYqwf51WnREv/MZAj/hNGyVriBD2YVe5pPO0
 /0xl8YPLNpCyZIcFQFic5ygwRh0udlinUrrp7RyfyTqxwzWGLt6YaP3AH5ucWU8fbBEq
 P0i39fzT48V41zt3LdplktqfrUylkZb0OlZ9ePo8G6Z+CYfrWB2CpR/aYqCtmXnyf7B3
 NGmnKZAJKLadnt3PYusXkC+3nNmQ4gP6aV+IPCTspP/wUWduWfIDT6FmHmNTo4fD5P8b
 0hGFWAHy3MMxW5iCBPzZ0OL9VV4kETUBZlTMuxTLY02/9pg/bmRi1/BwX0gnFo0nF4/8 Yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsaa76fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 18:55:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTGCGvf020408;
        Thu, 29 Dec 2022 18:55:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv77dgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 18:55:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAUJUz+4d9YgxhGGdkThZ8I+fWpIfKwBtluIWKNlhVYSmIv+gtYvVtGXsAw6prs4u2PobCJ/5hS66xJF6xixctcLc6KNFLJWme0fKDHFD/SzML0JfnoWg2sXjU6jkUgWyy/AJcIs83ZQiX078FhUy7TNqrCiRHEtv4sEvrMeT8cCsb4q4y9r2lppK7vgJdghxm486JFLqKjBXYc6+5fxCc8WKwVTH/w/HbWxmTHxrQjhiqPz/Mj1EpwuDPWg3YjxoIwpfsIOvyteYoBDnjEpe1bBt9Uz0Z/jMs9qsqzBguGPy/FANVCNKy/PFkUUcqh5j/TdQi+wb7DHo4+QB0UWPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y0oFrU6R07mH0dWvS6iGlkUbcFeTo4SmA7iA98Ej/y8=;
 b=mOmhMeKvGz4VNkUQSrJoOVwzypA9tUtlubjvoLSFRhGkRl648uCeVRji5q94xzlsxS9Y0RGiWc8WpSX9Tf0ACDJ/pCKR/UOboqS9CTtLWqLW+QtgwUDoONuZMK2XlUXPCvTRyE3TesMQm2DRfhNoFAeD4FB9f7E/etVt+sdUCGMw0aZpumgpsHTVqZCaDHVODaAzhd7hobCQazXbkwQE7A8IL1TSPoY9Ey4DPBsbf0ua0TObPPAUq4CJ5+70kKNCzwD449yYfpf2e644PEsb4uuaZi9HTg0Z8Xc5PIhUu3XGJjAFrfFV+ailtFoJyMinn6XXwl6i5J3ow3si1sdY0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0oFrU6R07mH0dWvS6iGlkUbcFeTo4SmA7iA98Ej/y8=;
 b=VSynxITnhqVnjk9+nXaYIFwmLxxUUcsTPOQs+4P50sC08jPGOJXo6cgUzp+jDeoBx+kqvChIX8Pv+KZychQ5ZuczxVlVEW4HOZUbo4WulDG6iTGcyXEBxk8XcXHUS1fCf4yn6IT+IElhG7hJv1Tmz2FH420AZnPRLpBz8/SdNhQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17; Thu, 29 Dec 2022 18:55:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 18:55:49 +0000
Message-ID: <8319d269-42b5-80ef-f103-ae9537d4f6b2@oracle.com>
Date:   Thu, 29 Dec 2022 12:55:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 11/25] scsi: move get_scsi_ml_byte() to scsi_priv.h
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-12-niklas.cassel@wdc.com>
 <598b6852-06f6-af3f-57a9-63cee9865b99@oracle.com>
 <Y6yp7G5WEWOwe+DB@x1-carbon>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <Y6yp7G5WEWOwe+DB@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5048:EE_
X-MS-Office365-Filtering-Correlation-Id: 1111106f-ea9b-43a1-f68d-08dae9ce4cf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 37FjG7u0pzths5ggegNil9JfUaEO59OBhTLFBTCB/liI1JNrfkG6cV0QKIqmGsZgMgzKOQjZneWJixlLCfgB5S9YJeorIAVRO3RnZPH6/LuY9XqyqmIFF5AW2qZSiyXXXRMe8Nxj3/3ozU/7xj86Hosf9mNwXVrbBg88vbjg/IId3wXct1hagevtUwd/LDulbPeWOhsw/emULNcczrsEI6ijKXisEqryGmfs1PnIYX1NeF/EriQMDAr5nfluEseenjGtjIfJZOOHUbuvqjwJZXa5Rqh7Bvgl5w8Btx3T75WUlYMI63+SF+fsOm0fKT4Uzh5FchhUcM25vkWYO9O2roWVx8Q1LaFJPoe4V8FTqbhU3zGSFTf/M7JrWN2Xva8U06yPl6zP4j309rFJVFzLXnaKmUKq22PUIFGIiEDMxvJQtivUd5HtBMdoPkJRC33ELcS1CqtSD2I4fPnRnK8GLHK9y95s0yyYB2JuEEyDZnvHzXyK0/W4nFGU8XQGxpE7+0kehahduEAbS9Jtp9B9Jz79HF+pf7V/13ArDyV+ZxIW7E8PY9FaGppmkIwV06iB5ZB/JoPNchNJHR99GKAVLrT8OWjELdZsN+QIK65Gz3Gj8RIddQfk46EVPRMgDqzJ4fOyUsRE1PPE5u69JmNOUTI7Wrc7vBhgRWZDeVUQQN89jMA3gbw4ramB7F01TmDfY1EsHWLi56gP2OUfrzNRkCoA3fFOQWm1cgHHcZPpWNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199015)(8936002)(66476007)(66556008)(86362001)(31696002)(5660300002)(31686004)(41300700001)(8676002)(66946007)(4326008)(36756003)(316002)(83380400001)(6916009)(54906003)(2906002)(2616005)(478600001)(53546011)(6512007)(6486002)(6506007)(26005)(38100700002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmprNXJwdnRhbU9sQ3hoazRFRjdIcWtMcmZaL2kreVpzUUExNHkrVEMrbm5s?=
 =?utf-8?B?d1I3K2tmOGs0eE50OXByNWpDdGRIUDVXamk4Rzl5S0o1VDk5RzJZOFRaOHJl?=
 =?utf-8?B?NkNxcTJaTmFEZ3NzT2JIQzFSSW5weG5zV2ZvRncxZmVPWGlTVjRtYlBzN0JL?=
 =?utf-8?B?VGZ2STBydGZyY2FqK3U4Y1VsRnZFUitVNngxd09MU2xQa3ExbzZRNU1NTEZE?=
 =?utf-8?B?ZUZubXJHT2VNekNqSmxvRzYwU21SV1BLZTd4SEd2RlYxanB1czNQQVk5RUM4?=
 =?utf-8?B?ZHBudFJtU0luNk9NTlR3VDNRRzlOelpIYTYvOU4vak1vczBjMFY4VHZoMTdY?=
 =?utf-8?B?SE16YVdRYjNNN0srallhZVpsdUV0YVZqTTgwdWJXeEZ0QUg2WExKcU5JSUN3?=
 =?utf-8?B?ek5QRkVnS3Y2YTJHcFNoQno5UFljamNXUUlydlFtYWZsRy83NnlFNTNINGZi?=
 =?utf-8?B?SFNiWXBlL2VWSnVsR0VLbVB5VVozQ3hta3dSaGVuQUd4L0Nka1M3Y3NyV2h5?=
 =?utf-8?B?WEwvVFVZdnM3UU1RWjM0S1Frc1hPTW9CVmkwUExGdEQraG1GZC94Z0NqaDlZ?=
 =?utf-8?B?ZUNwZURkdjFFZTlpUFB2QWsyMXZ3ZHZsOVZicWY3c2h0WU0yRFVuSnMzQXVo?=
 =?utf-8?B?Rm5WbkpUYU9SaEpjR255c29hSlE4K3NRL3Frei9hZFhqOFZGNHg2T2NGZm5Y?=
 =?utf-8?B?azRselpoaG1abm44OFV1dEs1UTlwcDhSejJKZHIyTHhidHAwNEtUQ3VuQTBX?=
 =?utf-8?B?dFpUWEdVcHdWeFRmdlhadjh6OHJNS3ZselIxTDN6d2hYUVgxbWNreUtSM0wx?=
 =?utf-8?B?ZEZId3V1QkFVNzFYOUttU0dqWFJxWmY1SHJTOGlTb2sva3dBanAwM29rYlVC?=
 =?utf-8?B?eVpSZ2ZBZnFlUnNldzh2cXU1clEvNWRET1QzbDZ0UGkyN2txU0w0RkxnbFBM?=
 =?utf-8?B?MWZUbWtuWFBtampraXFRYzBibW1WVEdwaFh6blIvZysrUDRVZUV6U2RDRUc2?=
 =?utf-8?B?bGt3Q0FpWHRjQ2lFMzdqeXZvb0VYd3AwMy9LajhnSWRORytCc0RYK0h1OWI1?=
 =?utf-8?B?aStnZmQ3cS9iMVZTc2FHeEU2d0d5aFlaTFBYbkMrTExQdG9SMmYrV2lteVNW?=
 =?utf-8?B?UW1IUENWa3FnejhqU0diNnlqem5yQWFJRzlsZk1MVE93MXlPVjRmang4N3JK?=
 =?utf-8?B?RmhMRWtKN3cxRElxbUZyOE80bG9PV1A3QkY2SmYvdy80aU9ZYStQM0RpTFI4?=
 =?utf-8?B?blQyZlA4WXRnT1c3dlZiUWFMTDJVcUR5L0M3TCtiZEZTS0h1Wjc1Zk1KUUJR?=
 =?utf-8?B?MW1WUXdJdWdyMEl3YVQxMG1kUWJhNHRvaENidWpEVXU0LzE2WW5VRitPaXBa?=
 =?utf-8?B?K3AwRzlXR2xwb1FLejhvZjE3N0VRajNtR3psS3piN2k3aGdmVjgzV2JjUDlY?=
 =?utf-8?B?b25meERyRzZoNTZ3Smo3dU81bzdUeTR5dUYvemIva1pDRklzd01UOVdIVDBJ?=
 =?utf-8?B?cjhFb0RCV3pUM2FZNHQ2MHBDS01BenI3ZURPMWFPMGVUZ3cvbUJENTNIbHdu?=
 =?utf-8?B?emxGZEF6NFBJY3JFc0lFS3QrOTdiWjkrenM2Ry93SVJ0NUZaL0lkdnZYVzVu?=
 =?utf-8?B?RWxaT0d2WjcrQllZK1RJSFFFUGZZcVZuajlRV3gwZ0dJUWpRbWRiZXdoKzhF?=
 =?utf-8?B?ejlwSHZwSHo0cE5OOEFOWFFNM1dDVG5qRjBVZFRCZ3dYTzFveWNFaFZ3STJV?=
 =?utf-8?B?S0lRcjJFT2gwcnVERVJnSjhReFF6L1Y5Yzl0VUlTY2V1ekhIQWZXaktQU2tm?=
 =?utf-8?B?Z1BCYnp5Q05LYWJRL2FaaVJhWE9xRkkzWDFyZXljTE1tNFdGNWZvRk5wU0xx?=
 =?utf-8?B?a1RaMC92TDlJVUdZbXZnNUR4ei9lM2h1dkpFN25BWnh4T002VXR3eWlDM2xZ?=
 =?utf-8?B?a01VMHhEcFlBSkRFbmJYenN6dVBNZVk1VG1rZ1NnV3FhWFdXTjJBVUJKUFNn?=
 =?utf-8?B?U3A1WThWVXhmTmlIeVNHQWdhaUJOSGJRR1Jjd2lGRE9hS3BOZi85K1VSUGh6?=
 =?utf-8?B?MUdpU2p4SlZROUFUMjg0dk8yOGp4YkNkWmQwUHo2R2w5Z1dCNjFjOTI4R3B1?=
 =?utf-8?B?Q0ZkOGZEM3JPdWJQcVJNYUVvZzJpZjAzOFNXWGNjQXRZbldXeUhINkQrTzRs?=
 =?utf-8?B?RlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1111106f-ea9b-43a1-f68d-08dae9ce4cf7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 18:55:49.2075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0pKIW9IBjjVNm0633PXfW1ioVb4IZf342mXBpy2N8l4Zl0K0wCV9F6ccPenPXqm2qFg4H56Ie4kzvV8O8TJuFWZSSSZOYXN27hO0iVEeeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290156
X-Proofpoint-GUID: mJuF6hgGoPH5XzwmIJUn3S-aJDHnTIW7
X-Proofpoint-ORIG-GUID: mJuF6hgGoPH5XzwmIJUn3S-aJDHnTIW7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/28/22 2:41 PM, Niklas Cassel wrote:
> On Thu, Dec 08, 2022 at 05:58:01PM -0600, Mike Christie wrote:
>> On 12/8/22 4:59 AM, Niklas Cassel wrote:
>>> Move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c and
>>> scsi_error.c will need to use this helper in a follow-up patch.
>>>
>>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>>> ---
>>>  drivers/scsi/scsi_lib.c  | 5 -----
>>>  drivers/scsi/scsi_priv.h | 5 +++++
>>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 9ed1ebcb7443..d243ebc5ad54 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -579,11 +579,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>>>  	return false;
>>>  }
>>>  
>>> -static inline u8 get_scsi_ml_byte(int result)
>>> -{
>>> -	return (result >> 8) & 0xff;
>>> -}
>>> -
>>>  /**
>>>   * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
>>>   * @result:	scsi error code
>>> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
>>> index 96284a0e13fe..4f97e126c6fb 100644
>>> --- a/drivers/scsi/scsi_priv.h
>>> +++ b/drivers/scsi/scsi_priv.h
>>> @@ -29,6 +29,11 @@ enum scsi_ml_status {
>>>  	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
>>>  };
>>>  
>>> +static inline u8 get_scsi_ml_byte(int result)
>>> +{
>>> +	return (result >> 8) & 0xff;
>>> +}
>>> +
>>
>> I made a mistake in the naming of this function. The get_* functions take a
>> scsi_cmnd. The ones without the "get_" prefix take the scsi_cmnd->result.
>>
>> Could you rename it to scsi_ml_byte() when you move it so the mistake does not
>> get used in multiple places?
> 
> Hello Mike,
> 
> In scsi.h we have:
> #define status_byte(result) (result & 0xff)
> #define host_byte(result)   (((result) >> 16) & 0xff)
> 
> In scsi_cmnd.h we have:
> static inline u8 get_status_byte(struct scsi_cmnd *cmd)
> static inline u8 get_host_byte(struct scsi_cmnd *cmd)
> 
> So I see your point.
> 
> 
> I understand that you intentionally didn't put the ML byte getter in scsi.h,
> as you intentionally didn't want a LLDD to be able to get the SCSI ML byte.
> 
> However, isn't the important thing that that a LLDD can't *set* the SCSI ML
> byte?
> Does it really matter if a LLDD can *get* the SCSI ML byte?

We don't want LLDDs to get the ml byte and do something with it because I think
it's kind of just a hack to avoid parsing the result/sense multiple times, and
the drivers have no need for accessing it.

If you put it in scsi_cmnd.h they can still do:

if (get_scsi_ml_byte(cmd))
	do something;

which we don't want.

