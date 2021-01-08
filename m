Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554E5C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA1223601
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbhAHEDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:03:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbhAHEDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:03:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083tJns067716;
        Fri, 8 Jan 2021 04:03:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ofGbowLnb1WZyso+yUKfgW5hddNxJdo1Us6Scpt8o1o=;
 b=C5B++WQP7XZucamLAtTBFohXCBoyqyihi+D5/GRlsTzYNzyDuI/0WHhtsh/xKKwrMFTJ
 1MtqaDoQodAgHr+QYG3/xnk9rJkt8BhOzem+MBqRjuhkOkQP7VKT8l7mVRtQppNzDPv2
 8YK1Xf7p6geTzYm2kPRUHQT+Y3f4WJtaHSQUPu0Ak4zmwJBf8ac/5JJrNQpKPZO8egm4
 zFSZcGLJ1GEVR+BR99/To8w5swxPt+/Dt4EtAh6DF5r8jrqsgzz5xm+5DQZzGsjIWmZR
 laP7Wf0o6xJOXTFL7fPS0KT1evbbaX9dMWKTguenwCDbDKIwqFpQ1oZQBS1qba/CYUX1 zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepmfcej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:03:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083uTaA004681;
        Fri, 8 Jan 2021 04:03:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 35w3qus4ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:03:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDiMNOhrXgziJ8HWTtVT3E1fGy6/wUJXTLEb/IeUrQzPdN/qVl6VsSLczuBe7vnpEUWcWXd5SD/RQfq7zPEFbzQqXUSRkF74iJ4IuGSDWeh67i1fZrbNPFyG3gLlmUGyZnF3IXwKfjhg5mb2/nilEPfVj30kMGh1CobBPBDdRLKlDlPlS7CD/u3+o4mMJGytHlui84KIibAsmFrFo6PDcyvxbXrXxbuoYAW2gF6EI8RvNCto8+jOn+gPPakGCL6IadMErnUjYRqcBhJSdOY1ETsLiWiNxINk6qYAhLef0wdRn+92AJkW0HOadRy+JoWcLu4u/U42N0PSH9HLkWABGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofGbowLnb1WZyso+yUKfgW5hddNxJdo1Us6Scpt8o1o=;
 b=iWGeFi+K1JRn2Dm2I2HkbaOGjKvOAdfi64MIljGWI73Dr2lJ5+TLHEy2bq0hlwMA04ZGbj+tNLBkIxyRNALQrIrLPyeLEE61ueC4dLqWtEvURhiMmdvqAJPfcJsJjAuDM4yc96QicEqbh0pwUBX0mGqkEvYoiWn+8lflINtzd9ilmQ7Jpa6KL3x8s0KUTQ9W26H1cOXsLux7I3pTAeULcNQO9CxhWrllIuyCLf9BsjN/sYVFLnRxYNbyGiVZP2qvp0KBVrqDCHgxjM4IFDoGmJ3vhtmD40fu9UI8Op7y0aFXvdaO2nDihpDk7FUKk0ms7rEpV+9JMXRKA7pl0T9OoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofGbowLnb1WZyso+yUKfgW5hddNxJdo1Us6Scpt8o1o=;
 b=JFrbIvQ/1cUMZoRe5Hf5wClfz1zfo8z2GhH/hqGQLJInsvyYHUDzHQYeaQW33j437Y/NKzE+8XvDmOuCgoD+Es2A9lfdOBDk+xDxC8IrB77JUwPci9cNCQiOBKniM3OZLssv7oAAmfgD+z+A0/JDoHK2qshqBIXgL6+jvq2iN1U=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 04:02:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 04:02:57 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/15] lpfc: Update lpfc to revision 12.8.0.7
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg7caxeg.fsf@ca-mkp.ca.oracle.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
Date:   Thu, 07 Jan 2021 23:02:54 -0500
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com> (James Smart's
        message of "Mon, 4 Jan 2021 10:02:25 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DS7PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DS7PR03CA0196.namprd03.prod.outlook.com (2603:10b6:5:3b6::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 04:02:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 136edc52-8e32-4b06-a613-08d8b38a48b9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46943F9447E3EA09BDAAD4538EAE0@PH0PR10MB4694.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nTKf+68cOGkCdAmqXM2nfhOF7ahvM1F9rn7e6cb5eiaC8041Nu1Z74B7DIvmhdCLwD3f7kLdRLWx1JKNLPFQhxaFMgraSIYmmm2JNMyvLAqcshAISIoPvbx9rIYjLcsrYeSkNTQuOlCr6KLlpqFJZN8f6tZf+Sm2jw7a7mgjWm3ku+I45N6d5TY/ptiLVKu9kUxGU1dNZbi3+kdzdvJ3mVsPkEYqP7PrhHuQ/j98P23dtXdqKVPEHGO52vReDFtEfkc04VtbCrh+EpGIz0/+hJg2O+sQ6XJcjWcQEv1dRvJWqvZlcXjpJseLBMaMMGLBiTghLk6p6XGwzeONhiRObqcKuWVElp3U5pJ+sWDc/qEuSPrEMD4app5C4382LxZlPxiXSeXbC7qqnB53xM/gcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(376002)(136003)(346002)(396003)(2906002)(6916009)(6666004)(8676002)(15650500001)(36916002)(86362001)(8936002)(7696005)(52116002)(956004)(16526019)(66556008)(26005)(186003)(66946007)(66476007)(4326008)(83380400001)(55016002)(316002)(478600001)(558084003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Evv33k/6FhornQyDKmNQFcSMYQ9QbJmZTZSNlmWsS65DHZwNFOVAx2Xdy54F?=
 =?us-ascii?Q?XcRKH9/x0S5vefsneanpMBJd1u6mH8gBkknLrpiLXXKVreU6FJ8U430HMPv5?=
 =?us-ascii?Q?EhEvtpeUe9afR6B2gMlFzMZ/tQmB9Ct1omfsz+2OppnrRNGvvx+xpbvUh7ur?=
 =?us-ascii?Q?UpUONAqbrdUGIKOrwJnSzNtebpAZyuM7xt2RJUm8gSKC/2iKDNnWmn/71Z45?=
 =?us-ascii?Q?iGueSqJSGhtjvLcxbL4B7cbyskeS8PtopvczvcB7aTOE0unS1zRLT+fVSmXU?=
 =?us-ascii?Q?tLtNI9ujSCq5gJcTCIGgWeLKktmZcnWSwLvv3V0AR5sr/gHQB52L/MAC6Z8p?=
 =?us-ascii?Q?VeE60Q/SvX8NsSGqWu+MOxrZcVgDeMvtFavDHvsvC0reaaYTyC/q6UWw+nYe?=
 =?us-ascii?Q?KT0iqeiCzYOyDtInKtdHreY+EReYXiUxc+rD0BeIoE7iW3Mfn4Sl6tTPo3O5?=
 =?us-ascii?Q?X2tbbQveLNtMVwYAifxv9ckfUZK4d9SC6Gvrl5zFXlSqgwAdxP1TdI5sbwXv?=
 =?us-ascii?Q?8jmIc+ZhofALys3kCFn9qehpvfFHwty5TEyhh8qrtRlkFFU0spiuLKN0RF20?=
 =?us-ascii?Q?nZ78dQxs9f7yoho0yTyvOF8MVz0BkyV1+CBJTqqZHjIqQvGIDF5A1Zlx+O9c?=
 =?us-ascii?Q?/hOvtVUCq2s+ZAqBH0QM97HQhH0hQXxYGJbcXV9JZhHVs/YFXZA1iUOIW1yH?=
 =?us-ascii?Q?7pDlruHfay6AhhNch13G9NPspimlVPJu+MLhx/8MfL1YuHI5CyylYys/Bm1h?=
 =?us-ascii?Q?ra2yhFginDAnlR8FDH4HxaZpzxqTHlh7VVFfTkbNfP227M9yd+0Q9Kc5VIYn?=
 =?us-ascii?Q?6EuzhdL4BziemaJEEMyXPnzyt6iaZS06rt12g2EERpjOxlKqAxDTg1RTXXxz?=
 =?us-ascii?Q?2wt7j71VPZ764YgePTqEDQ9t6yZdpuFmIlZjpuygD1K3cEmq3LKMoDCFFRLf?=
 =?us-ascii?Q?Y6obyNeUf6CqTHZJd66wgAjp4gbw7rjKeE2RCXGY5KE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 04:02:57.8655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 136edc52-8e32-4b06-a613-08d8b38a48b9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6RfDDaqWpb5M2FMUTCCyIGdgDrA6c6GCR/1Sv3/HGs9nM++ObouXnXriT60ejc1Ntnvx8YvO3gctUUfiUuVhoILnRwvb5LZbJB5lXCzAXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=945 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.8.0.7

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
