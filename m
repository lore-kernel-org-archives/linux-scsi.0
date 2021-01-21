Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A27C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C66DC238D6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhAUGcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 01:32:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbhAUGbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2021 01:31:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2huJ2143078;
        Thu, 21 Jan 2021 02:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9KMlmlaCgbxvgXYpQupB7NMNwIQazh5/wJyq6HyEK4I=;
 b=DTT/uvzPS6xfXsSOzTjOKV/ry2oNgrupwMEF2GygD8fwQYHbGDplYhKzrcLzfouEBaP9
 2cDKT7d/Ewn8K4KHQOJxvGVM1CkFYhul/oTOmmj4YXf2qfOJG5zZ6RAUBD9u5fdSEmmc
 C713Kw6bphiHT+kMj7eNP1DVTnVPDtFNPftmaIQXNMKE09wv9Uqrp0eskuAeGaR+D+uK
 lspKAwRqBW0bQNrwDPaaRek/GhP1AHbmi8ZufR3q2J3AFbcDqBC4Qu/ww5R/E7MOGlWu
 ZnjJaW498AiFjjR4JWeMd+OMAODGgz6YYe2FRxSGrQrXJOW15mMqKfcwKEcLe2b73JcX tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3668qad9py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:45:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2ijNu046545;
        Thu, 21 Jan 2021 02:45:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 3668qw9910-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:45:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqA80FUZu5+TXTQgOeJno+B10yznMdxUhbdMGVi/k/f6ZofloFRQ6qw6AZSaDQNL5fhvEJaoeptAk3213omxmwl6ysldr1pVcat2qEb2+z66+hXfmEMDNeMImSLQF+uj1oAfUsagh8FzTPPY/uYJ7kf0PQ31bJVhYyI4xSZ7n4K/aYRcWBQrNSXcroVhQqZ7z8u+LIdMIzoSE1kILaQJUuoA7Pv/zBEe4TLxtV8DzUNFCXSrDkFyPpUzJbcciB78nDbxE3Vdif1mgongVoBoyU0pcISHW5o/eW7wIViutgGMpcd4P+y4KvuT68JTjOR5JCDYTTyI7CiHs5+Wlz48Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KMlmlaCgbxvgXYpQupB7NMNwIQazh5/wJyq6HyEK4I=;
 b=PKqnrhGb+39Augewths7lkZ66XzX933c4XaPlLeeQn/tqIdcHzXqc95LI1cyXuocvKHcpoYZRW7LENpYUUrAw/mhw1UblZ+Buv1QtFQPfwgwo5C3jADemoxEhEqbdCJA5POAQYPHOqHqa4NJuaEe9LkSJV0C3Z6OzQyfmyeSsIK18mvLmyRjikj1bmvotaxs6hF2Z/8lqZyeJ0SyTnLrnN/8/6D2uFRdygPNAG0MQkGTthQ0BVw2kYudHKHf8rJYoDFKazwas8C3Vy2d0ShfwMdNRoG3eZ1V96EOWO4jmZiDhKkvn+skPTlCx+HOIsjZ2rpI7q3yk2ypJcRA4RKwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KMlmlaCgbxvgXYpQupB7NMNwIQazh5/wJyq6HyEK4I=;
 b=ii6Y1QGGozelwQc4tpO5EW8B8Pfi3Atqoc0BcOt7ZNaq+kfEzrgcm5Y2c+xQ7Y5NRp7NJHQ5/Qj2lR6k45q0jP8FftkIQSqEPDtXZQ72pMANVbHFojgHJqlsqL32sHj8uAzcLO0vC35mqgUDKK01Srk/EtsR64WNkkgZ7OgslYI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 02:45:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 02:45:55 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: delete redundant if statement in ufshcd_intr()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20210118201233.3043-1-huobean@gmail.com> (Bean Huo's message of
        "Mon, 18 Jan 2021 21:12:33 +0100")
Organization: Oracle Corporation
Message-ID: <yq1h7nbgg8o.fsf@ca-mkp.ca.oracle.com>
References: <20210118201233.3043-1-huobean@gmail.com>
Date:   Wed, 20 Jan 2021 21:45:53 -0500
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0046.namprd02.prod.outlook.com (2603:10b6:a03:54::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 02:45:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33d5a415-8485-4719-c76f-08d8bdb6acb2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4518460C932F89AC6E5643848EA19@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ec6o58pll5E2HEAtLCRRTPnyRz/9TPwbZOQE7bS+R+XF2/Aj8Lo8r6dNSXClhi8BQYPpNzugZierfkd47kV65xwSeFmnc3mghdOuRRqvP7LB2oMavhalT4mLAWk5JHWY+obVTvl8xCgIlmsz0c49R0wweLqGiyWMhOvO3hCHGbZLpkQkKOdS4VhSK/5EMDKZQ4OYIDuHdO7flhsIvfgI5OOzRn3YOUIkiG5fnISrCR9tFre6wjkhmoFaGhIch9pZ0M3S/vg3BvAZTgYkaJrqMhElZdfbGeE5xDVBTmmPpJbxa4piPaOu4ZLpVZB9tVoIKhbJsHoIvEh45kRtcqjIVklEEWWwftyyWC6Y0oIZxOvsw0S/ITy8BCa55SlW9+H/IJO7bUCylXBVyF+yGWZ3DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(2906002)(5660300002)(186003)(16526019)(508600001)(52116002)(36916002)(6916009)(558084003)(7696005)(316002)(66556008)(8936002)(66946007)(66476007)(956004)(86362001)(7416002)(4326008)(8676002)(26005)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qV2fK4vk94IiIU3f93jtFqs+/7XnBKR42GAkoZ6yiiDmYjNyC50N9P6/kZ+U?=
 =?us-ascii?Q?DWN5bWUHgXgVyX+x2pHGmKsPttey1Dm4QHPasm1457xg9eLtG0gd+VKYtpSl?=
 =?us-ascii?Q?uoQ2q93H1jjtn9CKwiJVFs25Juyn7RYggkG+PaS8EHdKKWuJXhKJI/5UbF9i?=
 =?us-ascii?Q?HH+g6/d/ydSgh+eiz3OzC/KUCLeDvpeL29g/g7Tw0E3aoAIcwWGOuzCNESs4?=
 =?us-ascii?Q?VwzfzP0oxeLEqYC9WIQ21kDgaoIhRQuhSi88Z2iyE9AQwjzyFGqSruKWMqMj?=
 =?us-ascii?Q?7DGrQP7qKSCU5ANHM+/WNfK4XDj5WldVc4mXJCbn+p3gh6BMksZLi0bc0UMe?=
 =?us-ascii?Q?SI/ml1OWBuga2wXXYgLnKTxnCvtRMP1+r12zZqfPJY5gQdtG0IVxaSrd9ucG?=
 =?us-ascii?Q?n3BvjIfLxwZPRNjj95x065AuJL3Oz2s1LXEKi9dwSX7RwINSuGR+a1nDV1Xq?=
 =?us-ascii?Q?n0msxO18m6OIAGFu3VZr4CBkbrzKqv7EJt4ZrZCT58RrEBOrT+TxBYT5rzuW?=
 =?us-ascii?Q?hC3fPosAtZ2tTgJgMdy6TrQIXBvenq/nngZCsIlJBXbznK76mtH801rTCbdZ?=
 =?us-ascii?Q?NlbY3cJ3yNfF9Xm2hvsiUkA6IdzPD8jYF4JQPhrtdej/OBenfwU2traoZUGz?=
 =?us-ascii?Q?GJNujC9MIf0SJwS8nw8iMWaCNY2EmKkoHj2WAh5iBcWaP78/eCLeRDwKqfmt?=
 =?us-ascii?Q?pMo5CjrGh5yrRaIbMqsxFXqqLQza/oPrh9ZQRiX/vxYKPy2MR31Fud2rlc+m?=
 =?us-ascii?Q?L3Mxv1+nSNCSUn9yzWlEyVfeCaZBFIkDu48qtzsl/oCmpe3i5eL9ry4xvx5b?=
 =?us-ascii?Q?yd0D+dxTafP7YFJ8tq06e0Lxnz72g+YgGdZY/LzLRk53KkjWPDTZD/xxHZqt?=
 =?us-ascii?Q?TEZ2/1+8sy6fnbIWXHMb+jBJQvtB2dUnsJmJ7Ce0mFr0s3EuKSBuyreUZcEu?=
 =?us-ascii?Q?azNscEnqtQJQDPdCg00qulAT9wVh0rhcbg0bVLo0o6g2cyFpb8bSxx5MC9RQ?=
 =?us-ascii?Q?/Qwk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d5a415-8485-4719-c76f-08d8bdb6acb2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 02:45:55.3025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMzBPEgILtA1A9xBc9lpOuzM4KgxRbyy5nLtmwlWbMTrN/4W05rYViNLV/iHUaX2XxD0n4QZ27xuNRlEcqKOarRlmqpMuT6vYv7O60exjSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> Once going into while-do loop, intr_status is already true, this
> if-statement is redundant, remove it.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
