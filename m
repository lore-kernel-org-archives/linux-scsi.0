Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2905C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC75C64E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhBLH2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhBLH1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P959016730;
        Fri, 12 Feb 2021 07:27:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=bhjY+7O+YpSMy5BzTmY8G8z2RPzmG94pATCAVQ3ucWIDwdKN95sziAxxLTynt0xwP+4t
 aiKbXgoJsTitPwIMcESpR7bAOakeUA1Oxrp9ObHNn3Hhjkh8lkw5b8oDrsqQKeKdBOGG
 tbcStI3lM1gLRG8RriV9+m/kz7l1UsSEVg04I1hYArbjMuqWwg8PDrh3Qfp1LDmGbSQO
 /qrVfXe7k8j3egaQb9Cq5XXmteQSparX0QdyOZp7y0KaIjjqSZy847BVI7CVLbnmQXvy
 zhTZ3SDWGe9jk9QkrlWJRJcKKXOgnzzVT2JeS7tdFfZRD/WeREf2mECNXNuno1ywEsqE YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36mv9dvcuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P9RM168446;
        Fri, 12 Feb 2021 07:27:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3030.oracle.com with ESMTP id 36j5214tpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5fJjscJ46ItLcibkiF2GTfkXA9rtQ4gYnw35Vf3hvV+mI+tG4Dh3opRBwvVnFwClxaNEkIUbrkGbStJSIvygSaQzWrbNjQIE3+rruexXzVjOW59hAsVJSYk+9qtIk9vK1phVaXvkmGOnXyfceilcoMZd7UPYbYyMlqfIDrDFSI6+6RfKkq+unEQmHlnLvnhxo5iqlicVZfOOsqRU4wTCfgQ0Q6zTv2w8iojg9+Ak0UEM6Ongngg2+6H+MgQjrBfWpN6b/vdlvFcdTwq1u3Imhnlg4oVYnjRPfKdoONlg7+a6HLrNJLVlmcf4brvNBA3Vi7aZdZZReQAqhDjZ/Lxvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=DaQrY7Y7bT2QHK+RBHkdjOC9VTVdZ3+BJXGMLaiVwm3EMZcgSyRj0Da0APoN13/X73WSTs5dquItqGZIaUcIVvQhQrJstrOHy0VMJlpsBcUFyCWKmKu7twoAXlXNX/Om4yytOjXoxfwuA9EBYIxXZF3Z5rhX2kuyBP/a35/teJzQYFKLKk63Y7n+qsQaV9m3Po3EvpMWtrMQQ/QbI2tYD/c/35RBvGPUJJbzZy9GenARh9wA4BLTeRYAnsdikr+72O/N3C6VqcolYUrqm9GJgmerERmYiWnMj43SsMXGYQd5jxn8Cm0xUjCkilPBQ4YG71+t8seDSzRV0M7McZNU+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=Ja4FFaqYX4cmwm+xPKYaiRXEFCPgMCVji22oMoA+M2xdh+KyYZ37Y+MjkSBbtHzfQoMZW4NchY6IrQ2urj+NqoeJXFh9ITSZhFY83PKvtpXb+ce5Z62jLbApqtIF1z2Qr927d039tpPyl3vm/t8ZMXMU2uIIe8Ard1foQ83MOk0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:03 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 10/25] usb gadget: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:27 -0600
Message-Id: <20210212072642.17520-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a29a7093-4ad5-4e7a-5a3e-08d8cf2797bc
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52544C04991CFE6CD988F82BF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebkDSY3VFNlhpj6Aylr9IZkO+UneAsTHsyWtk1p7WLrEm7V3hkb10kjHkARHoH0fghm1/lUR6uUUNA3AVPYstUbQDT9oPmXG2bSHFCzQ+IF6YKL6yKdmuQ1lohcd426zElVVTB7Xc+8zR4qPKdKY71oqoqwsAJd0R93iq1kdJ/934yJ5jUuVZBG99x5KTC9oogQ9LTWdt3q56LpDSLFrIAnfpQXYT+fFaEX6kX33/MKY7eL5lgZBNlnMSgHxL6CPplPhxI6aMKZY/TG42Wj/29DzyZ4uKHe0PakA3jOHmM0UQP/LmikvbqZVxenMMXi+3R+yubIjCgfj1+C7R3JBZN8SkugE9PLUWBt/owUefWyfheYL29ttJicEnfxq3vA8hsYNVMt4r7IgkqoKRC02AkV07hGNJSxgYlQUwzc+Vld0dFQ1vVyQIfv1GHS9cxOkhi007jNrq1pabaOMzDosjSv2nCL3ZqFMAEqEH+1cpJzbUtt5anLtUXq6GcLv1ZAyjOKkde+hT1QD5sQgC+TAvE9oD4gPo/NTdVN0+SbeDeMEXIJsx34aTNUIgeHPBqeLy7BCP14DlVhllI0MI5aKJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(26005)(956004)(6666004)(54906003)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IgAg+hUHXYDi6a1bRHhVj6jQh8+FGkQNgjbchkwKNGSafMAIBkubhWtMShvI?=
 =?us-ascii?Q?qWLbENF01LgDaBK1IiTrh2fiQyDeMuTgeZW/c03qZHw0VZB6AXEgAjmhfw8w?=
 =?us-ascii?Q?8Nsbw0jEk//+LwsyTx9z3pon9BUIEczuIaxZGUsT+p2dNGlvbpM6vGgSut3c?=
 =?us-ascii?Q?fz3BzfPFj/yj0JrFSePYWuc2970RK/q+Zh0oPw0yTv5y2Qvx1SLXGuvdpOfj?=
 =?us-ascii?Q?RaAFom+zzHcMVdgF9gu6sJAmr3exFuqdS7OFSz6GqheGIYSGB5Wn7s77vIEn?=
 =?us-ascii?Q?Pm7NnjMvBzCCqhebiC0REQ7Brw//aAjop9ZjOWAtlRtiUUpUFyCb3D4Fxk/l?=
 =?us-ascii?Q?4xY/iZmlUsd/Sx8nYq2xw2vZxh8Zfa4jAkY7qgSkXs4y3w0Dqwvny7B4DsEf?=
 =?us-ascii?Q?IxYfa5wRWcluWD/rrv7K+CJRc7xMeDk0X8kqOSTGDQ6fxysT5DEZKXzN012R?=
 =?us-ascii?Q?FEZKJJ6p3v1TSwPs8dEio00OjjWyCelUhebuL4EW7Bn8BPNqKRsz8EtVLrg9?=
 =?us-ascii?Q?HaU3nRipGbYP6eRrH+DivirwRGFx6J6gBrHhnopCHo8l4gQuNVb4WA7ywNht?=
 =?us-ascii?Q?sliCprgvVZF4hc1hCaUZhuaGA4Pxm4aJc/8uyJQ/S1nUnqbKbHzdZjHZ6FJX?=
 =?us-ascii?Q?+cublx1gDvOnILPLqmCeBEeMgxUHNcYc24mNl4z5O5zm8C5kjBGs7sPFdVJY?=
 =?us-ascii?Q?0o6QVKM1wG0sP9q5rW4eWfO/b3u2/HJdz88ZY38hB1aMrSEE1gY9fMLEOWUt?=
 =?us-ascii?Q?B02MHEMXZkRJigYGai+cbnYU3tj32L0INLH+LiKonk8BeuWjs2hHhVMSJTXd?=
 =?us-ascii?Q?1zrAbs/RpQCrGqIt1AkYxMl31dHsQIW9JXdEc7NbgsLrR7ZKfnEOXgSABJWF?=
 =?us-ascii?Q?i0nYS3S+8TvOEWcKBbKgN26KnNuFVEGgRJiCfnNu/UxS9ZscoreQfjDhbkZd?=
 =?us-ascii?Q?Ay1SNYpJhr6qQZsDSw4PNkvM7JH0D2jWmnLwHdc7K8LIWimq+ozEKBZ0uo6x?=
 =?us-ascii?Q?xW7BDhyNY1JKOFHjRW2yj9Xzfg6vFliTpeTC9II/jbUUmvjIEHAvamaqs72p?=
 =?us-ascii?Q?i6Jwwvn+hr4M2TVDQvYGn9iT5nrNWUNwTQaTljdL/t3T+ILHXKeIyIPemvA4?=
 =?us-ascii?Q?1leAgddkLgCdLiI7aSimvMhaXoZmB00U5N6O0LxGWMzFg7Rv3Vp33sFnB1Wl?=
 =?us-ascii?Q?ost+tXK25uhsV2ydR82YRvYSiGtQrltQSCBgwhY1SWAWds5P0CIGndiZoVoi?=
 =?us-ascii?Q?qkKToQaflMzrMOmVjNUyDrS/rlPrcnY6oe1vZ6ZF/qPhYqZx0XfF3vq5thuf?=
 =?us-ascii?Q?DRTwvbKL/vSe5elcdsRCKLH2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a29a7093-4ad5-4e7a-5a3e-08d8cf2797bc
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:03.1301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rTnPwvpMpBcHzVWE0KlYPqrbA5nJSw5sJIFiWqAh0lA2f1q4O2WRTDgEzEf4vKQboSvDw7jwRa+uy65bLoPF9FZgO/AvFnCIAtrsUYP6pKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Note:
Before these patches target_submit_cmd would never return an
error for usb since it does not use target_stop_session. If
it did then we would have hit a refcount error here:

    transport_send_check_condition_and_sense(se_cmd,
                             TCM_UNSUPPORTED_SCSI_OPCODE, 1);
    transport_generic_free_cmd(&cmd->se_cmd, 0);

transport_send_check_condition_and_sense calls queue_status
and the driver can sometimes do transport_generic_free_cmd from
there via uasp_status_data_cmpl. In that case, the above
transport_generic_free_cmd would then hit a refcount error.

So that other use of the above error path in the driver is also
probably wrong, but someone with the hardware needs to fix that.

Cc: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/usb/gadget/function/f_tcm.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index dcce6e2605f5..7acb507946e6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1058,11 +1058,9 @@ static void usbg_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
-			      cmd->sense_iu.sense, cmd->unpacked_lun, 0,
-			      cmd->prio_attr, dir, flags) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
+			  cmd->sense_iu.sense, cmd->unpacked_lun, 0,
+			  cmd->prio_attr, dir, flags);
 	return;
 
 out:
@@ -1189,11 +1187,9 @@ static void bot_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
-			cmd->data_len, cmd->prio_attr, dir, 0) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
+			  cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
+			  cmd->data_len, cmd->prio_attr, dir, 0);
 	return;
 
 out:
-- 
2.25.1

