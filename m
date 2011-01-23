From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH] target: Address sparse warnings
Date: Sun, 23 Jan 2011 15:05:14 +0100
Message-ID: <AANLkTimaYjUtOMF_zD0Mj=CPUdjVth_7i75AjWT9BgLU@mail.gmail.com>
References: <AANLkTi=MupdWyYnuY1rV9AkEobw8pZVO_-12JN6DteeJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39800 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1AWOFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2011 09:05:15 -0500
Received: by iwn9 with SMTP id 9so3184285iwn.19
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2011 06:05:14 -0800 (PST)
In-Reply-To: <AANLkTi=MupdWyYnuY1rV9AkEobw8pZVO_-12JN6DteeJ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Sun, Jan 23, 2011 at 10:28 AM, Fubo Chen <fubo.chen@gmail.com> wrote:
> Does this patch make sense ? With this patch sparse only complains
> about "warning: incorrect type in assignment (different address
> spaces)".
> [ ... ]

Sorry, forgot this:

diff --git a/drivers/target/target_core_pscsi.c
b/drivers/target/target_core_pscsi.c
index 4d7ad58..3546e9a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -490,6 +490,7 @@ static struct se_device *pscsi_create_type_rom(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt
*)pdv->pdv_se_hba->hba_ptr;
@@ -524,6 +525,7 @@ static struct se_device *pscsi_create_type_other(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt
*)pdv->pdv_se_hba->hba_ptr;
