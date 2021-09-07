Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C167C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 21:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D0E161090
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 21:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346536AbhIGVDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 17:03:40 -0400
Received: from mout.gmx.net ([212.227.17.21]:52233 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346428AbhIGVDj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Sep 2021 17:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631048542;
        bh=/X+1a+rT4ZwFQFh3WRVQzSRpQLReMSBTBZgfHqg5CD4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=LkL3LTCu2l+Z1aUt8J1q2tQjA8s61PPMFka918W0g4daGupXVXO9j0dwA5GINN5Se
         WhBOAPkyr9AOcV2Kd1aKyaAxh/Pz+l/8nfb+UAtILJNL4/zwiewMktLP7lLfyXzaRc
         gQIe2o+QJSTR00ILtonXCE7DT17JpSXCM4htLIzA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530 ([80.187.121.129]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8hVB-1mJ1GZ0Thp-004o2U; Tue, 07
 Sep 2021 23:02:22 +0200
Date:   Tue, 7 Sep 2021 23:00:44 +0200
From:   Helge Deller <deller@gmx.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.com>, linux-parisc@vger.kernel.org
Subject: [PATCH] scsi: ncr53c8xx: Remove unused retrieve_from_waiting_list()
 function
Message-ID: <YTfS/LH5vCN6afDW@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hn8PmxDZvIGVE7ig3UrwMaY1h/3OCof3sEOOh6kCfuTvKSNjNF7
 9jYXCRcfonsIzkTt35wfD75Y84oBLtasooYgEhDUiZhMqcvfIBGTj/mfNEieLvJL24DDoo7
 I3BZ5JOSFUepFjFhAWKWtVmsMEWgEG78qUMGvaahMDDxEsPyh3SzNSJLjq8qC6742aG+yI/
 K2Bh6Bl6mf/EGAjuYaHBg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WGkKda83z3w=:SyYALqs9idC6IRkvEfFlX7
 ycC8UtJfJA7ZC8WBmt7KUVd/bIzfAWL0czTOfMe2kuqQJV3ZiVZB7AJk9PkrpGdsMNx8frs/B
 MilwUWxXLFmQqWEsKiHGMM3y2FoWkqjCwVEHHYdsGk8dAArAIPCOESZ8/RqGlr3Krp0uzOG6l
 tnXpgPLXTQ1EPo/beD3AW4qeBkd3jGvXO7CwN34LHebo2kgJozZH7MvlkUVYdjtbHJXIrlAqj
 PSQWox5YYwmOT61Qec/Dv45t09Llm9ZZoZMjbvodfFMRXcGPjkchXrhnwWL79lpxX/N3H+db3
 bHp2q/iBKk8s6qVUWGRug22lNuGAH/72fFdQFv7vqkirG0JDCv13XtArt9UC5Xp/kZ1KNWmA+
 kg38lJL6TuhNKBUNpliBVOxxg5fcSGNtFZqQAGLK1pbWgbAR+L9MVpCN28DoqaMXLPiq5+Pr9
 WAnX7/VOHlp3z641JeY3pQKsak5WvDic0ASW4GaaiAucpR9XDrD7NvFhG1M+jShpKj15QFiAf
 89n+uzVIAei/Y62KhHXv2VKi4b/p6uH7+1yz41I87Dy5QruWnJsZGpNbu7Se2T4tXf90vmLIB
 US9XTq70wozoZmjvnsA4ZrI8oMbCwtmkbht10wll3Z6iHUamwfz3zwwrc+DaiPAqRV+Ya4YC1
 V4vdw50ER7qHQVWlbyBtqDw9k706F1INL5+XtU0URnQMApt6/3Ocy7BIhfCOyaNAGXfWw5uG7
 +J/4t0dvOE6gI55W5zJlKAM2u/W+rLFjaZIpPSL7JDSKmKAwINgxCkMZEM0ThvCjA7B6ewJXJ
 KU1SFnOMmwhFBBjZnqMm5JbES5aDb4N53XRxsYPQOgjg3kK3go40S7NcNRMfpE8sJcFMKhnP1
 p9CZAG5AdC7j5CZ/Bf1YpHED2gXL4v33+jNtD47TfOS4mzzaEc0ZQ+MLo6fg9sUoXktHD+4su
 +Rj23YTGIcAlDvsODk573zX8Vow4J0rsnwxbS3mep5HXzZv5xCSD87Wv6UM2Avom8DdprfKT8
 CMxt3kmGLJPLWqmeXO4DoOV0dWgSdfMi8gQRElkLXJr8i9gF6zM3q/tNeLGsvO7++Sajn+Rd2
 TIAWLUKZYjdXBXVdiTfyRFLcolQMjJ/Jn9yXtD9Jxx9sCWDWKd/Klr0fA==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop retrieve_from_waiting_list() to avoid this warning:
drivers/scsi/ncr53c8xx.c:8000:26: warning: =E2=80=98retrieve_from_waiting_=
list=E2=80=99 defined but not used [-Wunused-function]

Fixes: 1c22e327545c ("scsi: ncr53c8xx: Remove unused code")
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7a4f5d4dd670..2b8c6fa5e775 100644
=2D-- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1939,11 +1939,8 @@ static	void	ncr_start_next_ccb (struct ncb *np, str=
uct lcb * lp, int maxn);
 static	void	ncr_put_start_queue(struct ncb *np, struct ccb *cp);

 static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cm=
d);
-static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct=
 ncb *np, struct scsi_cmnd *cmd);
 static void process_waiting_list(struct ncb *np, int sts);

-#define remove_from_waiting_list(np, cmd) \
-		retrieve_from_waiting_list(1, (np), (cmd))
 #define requeue_waiting_list(np) process_waiting_list((np), DID_OK)
 #define reset_waiting_list(np) process_waiting_list((np), DID_RESET)

@@ -7997,26 +7994,6 @@ static void insert_into_waiting_list(struct ncb *np=
, struct scsi_cmnd *cmd)
 	}
 }

-static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct=
 ncb *np, struct scsi_cmnd *cmd)
-{
-	struct scsi_cmnd **pcmd =3D &np->waiting_list;
-
-	while (*pcmd) {
-		if (cmd =3D=3D *pcmd) {
-			if (to_remove) {
-				*pcmd =3D (struct scsi_cmnd *) cmd->next_wcmd;
-				cmd->next_wcmd =3D NULL;
-			}
-#ifdef DEBUG_WAITING_LIST
-	printk("%s: cmd %lx retrieved from waiting list\n", ncr_name(np), (u_lon=
g) cmd);
-#endif
-			return cmd;
-		}
-		pcmd =3D (struct scsi_cmnd **) &(*pcmd)->next_wcmd;
-	}
-	return NULL;
-}
-
 static void process_waiting_list(struct ncb *np, int sts)
 {
 	struct scsi_cmnd *waiting_list, *wcmd;
