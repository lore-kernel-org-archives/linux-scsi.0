From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] aic94xx: Fixup compilation warning
Date: Mon, 24 Nov 2014 17:04:06 +0100
Message-ID: <547356F6.3070404@redhat.com>
References: <1415085059-127936-1-git-send-email-hare@suse.de> <20141124134014.GA22128@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaKXQEn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 11:04:43 -0500
In-Reply-To: <20141124134014.GA22128@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 11/24/2014 02:40 PM, Christoph Hellwig wrote:
> Can someone review this trivial patch for me?  Thanks!
>
The compiler complains because when asd_find_flash_de fails, the offs is not initialized.
When that happens this code is invoked :
        if (err) {
                ASD_DPRINTK("couldn't find CTRL-A user settings section\n");
                ASD_DPRINTK("Creating default CTRL-A user settings section\n");

                dflt_ps.id0 = 'h';
                dflt_ps.num_phys = 8;
                for (i =0; i < ASD_MAX_PHYS; i++) {
                        memcpy(dflt_ps.phy_ent[i].sas_addr,
                               asd_ha->hw_prof.sas_addr, SAS_ADDR_SIZE);
                        dflt_ps.phy_ent[i].sas_link_rates = 0x98;
                        dflt_ps.phy_ent[i].flags = 0x0;
                        dflt_ps.phy_ent[i].sata_link_rates = 0x0;
                }

                size = sizeof(struct asd_ctrla_phy_settings);
                ps = &dflt_ps;
the dflt_ps is initialized and the address assigned to 'ps', but none of them is used later
 }

        if (size == 0)
                goto out;

        err = -ENOMEM;
        el = kmalloc(size, GFP_KERNEL);
        if (!el) {
                ASD_DPRINTK("no mem for ctrla user settings section\n");
                goto out;
        }

        err = asd_read_flash_seg(asd_ha, (void *)el, offs, size);
        if (err) {
                ASD_DPRINTK("couldn't read ctrla phy settings section\n");
                goto out2;
        }

        err = -ENOENT;
        ps = asd_find_ll_by_id(el, 'h', 0xFF);
here^ a new value is assigned to 'ps'


I have no idea what was intended in the originally so - it looks likely, but how do we know that
the '0' is a correct value for offs?

Probably the error path is never used, this patch should fix the gcc warning too -
@@ -990,20 +990,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 	err = asd_find_flash_de(flash_dir, FLASH_DE_CTRL_A_USER, &offs, &size);
 	if (err) {
 		ASD_DPRINTK("couldn't find CTRL-A user settings section\n");
-		ASD_DPRINTK("Creating default CTRL-A user settings section\n");
-
-		dflt_ps.id0 = 'h';
-		dflt_ps.num_phys = 8;
-		for (i =0; i < ASD_MAX_PHYS; i++) {
-			memcpy(dflt_ps.phy_ent[i].sas_addr,
-			       asd_ha->hw_prof.sas_addr, SAS_ADDR_SIZE);
-			dflt_ps.phy_ent[i].sas_link_rates = 0x98;
-			dflt_ps.phy_ent[i].flags = 0x0;
-			dflt_ps.phy_ent[i].sata_link_rates = 0x0;
-		}
-
-		size = sizeof(struct asd_ctrla_phy_settings);
-		ps = &dflt_ps;
+		goto out;
 	}
 
 	if (size == 0)
................

Somebody with access to this hw might help and test "offs = 0;".
It's a question whether we should touch old drivers at all.

Tomas



