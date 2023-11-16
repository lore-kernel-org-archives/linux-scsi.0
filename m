Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0A1C197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 16:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjKPQ3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 11:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjKPQ3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 11:29:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1371E192
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 08:29:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGSj1l031851;
        Thu, 16 Nov 2023 16:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qeABiCvX7sMe7BzU2bDGh8V/H9c5oHFJcTsp3BX0R1c=;
 b=F5KIuq9reGRllGkd+sQ2zqYpAdga+RKRB8GvXYwLR4f6KkGHCL6YLrdy8ZwK9T8FaW9w
 3M269MZ/7xcKdE4SVELDg3FsmjKGo+WHinPBhYF2pjyjh/0xlJVMk2E3d6bAFrCFpvIS
 C4UT63Nmikf/x18Owehmt3jw8vl1jxw5RSoNYzC6hWgDForD/RJU4dBkY98iwynjaxVK
 Go0xGOZ29XcJ1TItbIGNM2NW4WHzp0v6YEZO2x1Tsxohd/MA7aEgFCegUNZ3dy5RjVGm
 cb7nftJ0mIav3cqSabolyEWaulAI4ot5sAZi5lWCWGblv3+vrDVuoObTNlQYAPSsuzsq nA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2na3gdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 16:29:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGQ9Rc027458;
        Thu, 16 Nov 2023 16:29:19 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxqvckw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 16:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uv1ABhJKF5+Qj5QZBRfeszcnZiJu/oi7UqNdsIi7BQzp53QGKdH1d9oYy9GonrjXUHknWja/eDRSvOIb4gFOxsXDqHCUcq5Lf+kDBpJkMGPtlrxXyD4cFW6l0/Nml0JrVaRGWMkiXT5YOdX15ZKZ4QBXx2Xti6iYrrYU314pcwtikJPiRmrBMo56/hr3tZQOrq4s0SE0LS7vK532nkPiPZO3P6h0ZLXOctyuTZzB1g2vRDyzSZwPh3i+5ri014VAw0BDfaD8NqLMocOJqNCVbi3b2CQWmSXgWqUGUiHOE4gVLk2OuE0jNYuUfTXQnxEZZTOpc2IgCG5PNjvMig4zbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qeABiCvX7sMe7BzU2bDGh8V/H9c5oHFJcTsp3BX0R1c=;
 b=MHo1vorAksFnC04FSXM+XPTH9lcjPygyMN1o6C1PRdp47JX/805EgRvhXzQO8MRUjaXkVuQoLY7qcUzioEutt4MMEgmZbKOVqMORXlLTLyLtwyf7G9Y/q1MdlJW2EUSw24tDoGkEafh10k6qnVs3AEuNp+3Ep+czVqVJaQt6yvhC/kIIamuumxJaBDGiiCpmRs6k6dgKp9Vp+E/hWAmF7cxjNQprybxtIr5tHlbmMC3AAdjJUHqprzbeQcPgim+5E039MK368Ivyi/p1c/Zwcx+T0b7I5xZbJh+2jAF/LyBnaf/PAkN8WxpUayhDWAVra4+BSqLAj+QMPf00Sz0wEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qeABiCvX7sMe7BzU2bDGh8V/H9c5oHFJcTsp3BX0R1c=;
 b=V3aW34J5sMJN30Yh9EyjWOuae5sQW3vq4Olkuk6FYuWCafgsWi0DhwbH3Z8BhqcGf5h88L+RSsJXOeQLrnrK+CXAaoE6SDENbqrbT/1rXeYIkNsDemMElb94gc9nUTdAuUfwvOOB/acb5Wwz5aqNERLoaKYBtOrLWP52Mall1OM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4954.namprd10.prod.outlook.com (2603:10b6:610:ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Thu, 16 Nov
 2023 16:29:15 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7002.019; Thu, 16 Nov 2023
 16:29:15 +0000
Message-ID: <5aeee967-7c69-412c-8591-dfaf5727edf5@oracle.com>
Date:   Thu, 16 Nov 2023 10:29:13 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/20] scsi: Allow scsi_execute users to request
 retries
To:     John Garry <john.g.garry@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <0b3a1520-1fdf-4f6e-97d2-fdbc47fed039@oracle.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <0b3a1520-1fdf-4f6e-97d2-fdbc47fed039@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:5:74::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4954:EE_
X-MS-Office365-Filtering-Correlation-Id: ca714c3a-ffc0-4af7-40ab-08dbe6c12c1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: On9VhcuwjqNbGQM1Tz2lSeIS9Zcb520WmbVPiExhNq5K15Cw8hSP25d83Tw5vdKE6faAVZweqgkU4OtYmG7CzEI0FGs0GarSeJz0JDtbQ6rqDnk15f2Fv+9V0h0rB6HgjQE5TWMCSjMx8attJoA1PYrXiaFnGu6tbJ6T0Wxgybv34cj7oLEIbCsCxbbCWNMLZM5q5TgACZWVi2DUjB9Ppf9rMddj4/MOjMZsd0EWMBfsMGkJ9+7bCQk3gc3VlEwpHSkaPkmWUO+KHa5bFdq6qIkkPp/KCPrFNde1VCdWBNk3JRaR1UJlVEJ+f2CdQ90kyqccFzNFFC4ZAdiGnRvnycVOtBCCaeoEsESJZYqzAUu7jIduIH29nAKrC1FvjsEXOH3n0zn5ZU2A5LzUXum7aYbumAoF3S4RfD4Es4vd0kq3n9i8GZlVYExRWBy8Fc9T34z70GO36GFYeEGkYQI7jLnVfw05qM1chFrqcLPi6bMu3YUTO1mgC3hqVNv5jw0I5rXwBMMVCs5NpMAr4c8XcQbSDn6Io8N9TMDjfDYyFLneUiDG8VbDBDKojyvEktN+uzDtw8w0eCHgiNlNva57M2pP7cbgjiCZ/FtcuWunWwHdzL5Nw5nGqC7IXYTaW3ZppTQlis3y8sFtoXyAcAvTqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(366004)(396003)(346002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(38100700002)(31686004)(2906002)(36756003)(86362001)(2616005)(5660300002)(31696002)(26005)(53546011)(6512007)(6506007)(41300700001)(8936002)(478600001)(8676002)(6486002)(4744005)(966005)(66556008)(66476007)(66946007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d25renpGSHREbjhHcGRqVlcwbFNmOFFneDVzMWY2Q29qaXdZRkN5NHBONFZm?=
 =?utf-8?B?RXB3VHpuT1RoT0UxWDhvT0d4Ni9oRDlwbHl0T3c3OWF2NmNkWjBzTTI2dytv?=
 =?utf-8?B?c0ZiVCtUU1U4dnB0SmNmS0FVNWxuekJ5Vk5sdkVNcElWcXdQanVaMGlURTls?=
 =?utf-8?B?YlpCOGhsRTN2eS9NL2lLc0UxT0VTZy80dW4yTmVqNlRsdEJRWk4wMXhHbEZS?=
 =?utf-8?B?SHdHQzIxQ2FHd0tXVnlseTVESjdjcEN0T0Z2TElqVXZOUVR3SEFZM1N1eUFj?=
 =?utf-8?B?YVVuTzFzUDh0S002UGV6YXNYMUZoMHpuS1ljc0oxMVNGNDJQWERmcVdqREFI?=
 =?utf-8?B?VmpXVkk3QjFMZnQ5OHdoZUMzMlF6VUFySVdscFdoanpwMVl1SGVjUEs0NUNy?=
 =?utf-8?B?NExWY21UK1FoTC9UZWxHSnFaNmVBWDlzV0k1TkxjenI0anJrMkUzWm9ycHNF?=
 =?utf-8?B?SVVXVURZdE1kaW1TK29jbEJkTi9adTU0WElPekJKUDV6U1JJZTRwMHFRK0FG?=
 =?utf-8?B?Q1FzT0pqakRBRERpTW1EOUNJTUtrWStielBPL0syazFRVE5ybEJwcWVqVUpF?=
 =?utf-8?B?WXI2Nm4zU1hhQXVlMzZvUlZqV2hGU2lld2Y4MThqM1A0bHJVbGMySFFScHFB?=
 =?utf-8?B?QzdkWlVTU1NOdlBjQ3BkS2t0N2E5OWczNFR1dVN2Z0hXV3p5REVMNU55cWZG?=
 =?utf-8?B?bnhBUXFSUEd4TmpMbUZacEcyNi9VaHB6UkV2WkY1WjVWUG9OSzkvSFR5QkZ4?=
 =?utf-8?B?ZzNkQ3ZmaXhLRWNrTjh4bDIvOGxtbFlCd1pvQmpjZHlnT0pyQ05yL1NCNHdv?=
 =?utf-8?B?YVVTaHRpZTVTb1NBRzJTdE5qbG5ySEVnRXBvcDg1ZnM4cHM2K24xNFU2ejRn?=
 =?utf-8?B?SDJZaituQXNCMUV4dEpZZndjME9OUytVak5XQ2d6ZXF4ODAxc29VZXR0QWZx?=
 =?utf-8?B?TUpFTEVoUkVudCtmMTg0SW8ydnV5NjhQSDlNTTlzREhTV044c0JCVEpubVRN?=
 =?utf-8?B?VkxzWlBYM2VUVk42L1JvMGI0QVZkR1lFdmZ5TkVLRHNEQ0RnckNReWsxVHBa?=
 =?utf-8?B?d3FZQVVIdUVUbXFEVVhrWGJ2ekF3dEhyMVZKQnM0VFhJUXBBWFA1MVhQSGNR?=
 =?utf-8?B?WEErNk1hTldTZTdzZm9qeEJlQ3UwWGNRSys4elBRQk1keVlwM1BlT0FxSXFU?=
 =?utf-8?B?N2k5ZTNhekZaMVk5U3N4NVhyU1NLQnVVdWdpKzdnTGtETTE5aXROMjFMZnlU?=
 =?utf-8?B?eHJGbUk1enFVTTlYbFBXVXNiQXdQMGRNc2JWTE1VTElxRGljbHdjeUF6Smh5?=
 =?utf-8?B?VUJwQ2J5N0EzbnpRVlBKeDY4N0lwV096dVNXMndES3BjQW5ZVEx3M01aMUln?=
 =?utf-8?B?WE8xNXN5ajBTYkVqL3krdDlhYlRvaFdtQXI4Z3FYYUlYNWRuWU53bi91eVhK?=
 =?utf-8?B?STIxL21Zd2U5SFNlQ2tTb0hsUjJ6N0VoVzNQNzE2TFJudUtsMm9JNlZoMTBh?=
 =?utf-8?B?eXFkYklIaitkQ0hDUGRLYmc0QlJ5VW9odFFuZ1hXTXpGM0diNTlVbThwWFB1?=
 =?utf-8?B?My9sLzY1TnlhamI4VXZRek45QXpZUzB5RE5JTk9oSHFtRjlHeVhUYU9MOVRG?=
 =?utf-8?B?YUhKMmVEK0xQZHVVUXd6QVZTRHNXNVFvTytsNWVoVS83emZ6WWtiZnFvSy96?=
 =?utf-8?B?MCtJcmFadlJzeW51N2NrKzJ2WkQwYWpWdENSWjRleTRqc01jNmYvNHQ0ODRy?=
 =?utf-8?B?U2dWUGJ1Ti9COTBFc2EvVHpNUW1ublFrenhRYmladU5ucEhDOHhRNkhTcVlT?=
 =?utf-8?B?M3FtNkYwTnAvZktEMmNVS1NJWGhocElrZzFvUFFadDdHMTFPWDJ0Mk5xbWpa?=
 =?utf-8?B?N3NYMlRJZ2VJd245UnA4WHIvSlJLeEJ6RS8wOWFHazhGWjVDR0cyYk5DMEVv?=
 =?utf-8?B?ZmNBSmx1QmJ1MU9pNk8zbHlNbnE1K3kveHVuL1VwL0ZRUjJwNDFvTlZyT0Zu?=
 =?utf-8?B?bDJvQXh0bEY2cEx0Q1kyZ01SQk15TkVjV2RFVkd5YUJkcEV6QWlzMkw0OHFv?=
 =?utf-8?B?eGc3QkhWdEFmTDFERmgrY2lvRjRWaDRUUUtpb2JCSHZEc1ZiMEtlcXZMRDRk?=
 =?utf-8?B?ajZiOERuOVF3MDU3aTYxM0dCd2dRdUJ6WnA3SzZERVhXRFVBQ2hsR0c1WW9y?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XDK0bPbesxj2PHzOBVL3LDvCH8LNNPTsDe05XcgndEqhcF64QO1NHCgzDiUIvk9pr9YjPXtBNrjKDY4KhoSUxlcuQD7w+0hL1869zoVrj7GOqmiVLRhxLVId3vBIrCOxKpXfSR+ETpSy3NFvqHPkZ4X9OWzALSfLbFYQ4KUJDIQAlu9GIWjT1wKhB0EE/LaBp7Fcq9qs5uU4pPl9tlMuSRTVZ65WMmhxxNkOdyema33J2nuE+1SJ8CaDvQzkvBrXkRqgqkkfr/456Ai/rRr5SGK/neV9C56UxHWlYBtCaZMg+jUfTlDDx/Y/vAAuxIyMCj+zIg33TqtrM3ofxfdpo6ahM9W3/UAAkHvMwRUhCnGzSIvgO9cvyaJToWwmVuh9M07HHDwp9LIiOBtR/CtDdjmHc6upuXbWUrTxQqtnmg/wK5aV7UV52V4317+wDVKQegeO1Ob5cYp31rFN+XWmKHqhqXnoiFnxBK0oSrms0aOMF9B63NCr+cU93hxRlK7FiVrxp1dmGxPBUw69f68WF2sIaNlAbHJ0uy6Ges+n2K6TnJaMGEQyPBJ6g7awvgs+SUzB8f0X5BG5uhmvvJS2AirlizCmhfkVMhMT+fquMUWNZ3yCZdO28Vw6KuZbpWQHt7ztJAHZFYdlF7XtzkUYYCtq6rYW6KlIeRWQZ3zz1ZY9RvqRz0LezWAwCPNm5wDW+uZSwPLsJiixyrDaZdBB4HmOyYQo6lSPkCImf1RTCDBRZb/Z/2vcwAyV/U1XaX7KTEYIHwWUCVUPouwwIhWPtiuOUoMZOu6iqzQKXwdfoU0Ci6UlwqZ2ThcyeLzeCxQwn89vWOeMQIdFgYtoj33djuZWH8nNAsgt3mnnAXww0iQzwgAgzBLzXymv8JHrD52J
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca714c3a-ffc0-4af7-40ab-08dbe6c12c1a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 16:29:15.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jfqu+/oWuAB4+O7mTc/+J6WEhyRUmlVf0fxmoHgLY+fiPDfeY5fa6uLEFs9TdY/DEKxiaNl3DRKf48CZnYFNGa4KcW9yzM8UmycZN6k4REg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4954
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_16,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311160129
X-Proofpoint-GUID: a3Mw8m7OvY7_RwUs0RGXFO3LtTcIzdgK
X-Proofpoint-ORIG-GUID: a3Mw8m7OvY7_RwUs0RGXFO3LtTcIzdgK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/23 5:02 AM, John Garry wrote:
> On 14/11/2023 01:37, Mike Christie wrote:
>> The following patches were made over Martin's 6.7 staging branch
>> which contains a sd change that this patch requires.
> 
> Hi Mike,
> 
> It would be nice if we could apply to 6.8 staging - was the sd.c change not in v6.7-rc1?
> 

Staging didn't exist when I posted this.

It exists now, but is missing:

https://lore.kernel.org/linux-scsi/yq1zfzn4p8a.fsf@ca-mkp.ca.oracle.com/T/#u

so will not apply to 6.8.

I was actually shooting for 6.9 so I'll figure it out by then.
