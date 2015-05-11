From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: sysfs group not found for kobject on mvsas drive removal
Date: Mon, 11 May 2015 15:44:22 -0700
Message-ID: <CAPcyv4iyaCDchXt93aw0cjqcvL_RPZDU-LendmdhS7G8_AUxMA@mail.gmail.com>
References: <c952e6a1dc4b4badb3b4a55272bfbc48@EX01.lg.local>
	<16adc53b67b247f49bc46ff20a9d55d4@EX01.lg.local>
	<CAPcyv4gm7Ss5Bim--=9i_G2J-OmbxmKuMU_zcAJ9pJ8_0Khqjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37319 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbEKWoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 18:44:24 -0400
Received: by widdi4 with SMTP id di4so115735564wid.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2015 15:44:23 -0700 (PDT)
In-Reply-To: <CAPcyv4gm7Ss5Bim--=9i_G2J-OmbxmKuMU_zcAJ9pJ8_0Khqjg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: "James Bottomley (James.Bottomley@HansenPartnership.com)" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, May 7, 2015 at 11:25 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, May 7, 2015 at 11:08 AM, Praveen Murali <pmurali@logicube.com> wrote:
>> Hey Guys,
>>   Am I on the right track? Or am I missing something?
>
> I'm still paging in my libsas knowledge from slow backing media :).
>
> I wonder if the Intel-isci driver triggers a different ordering on
> remove that avoids this...  let me take a look.

So I wonder if this is a new warning, because as far as I can tell
we've always been double deleting the devices below sas_port.  It
seems we should delete all the devices from rphy down before deleting
the parent port.  Something like this (excuse the whitespace
mangling).  Only compile tested as I don't have a SAS setup handy.

diff --git a/drivers/scsi/libsas/sas_discover.c
b/drivers/scsi/libsas/sas_discover.c
index 60de66252fa2..a4db770fe8b0 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -362,11 +362,14 @@ static void sas_destruct_devices(struct work_struct *work)
        clear_bit(DISCE_DESTRUCT, &port->disc.pending);

        list_for_each_entry_safe(dev, n, &port->destroy_list, disco_list_node) {
+               struct sas_port *sas_port =
dev_to_sas_port(dev->rphy->dev.parent);
+
                list_del_init(&dev->disco_list_node);

                sas_remove_children(&dev->rphy->dev);
                sas_rphy_delete(dev->rphy);
                sas_unregister_common_dev(port, dev);
+               sas_port_delete(sas_port);
        }
 }

@@ -400,9 +403,6 @@ void sas_unregister_domain_devices(struct
asd_sas_port *port, int gone)

        list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
                sas_unregister_dev(port, dev);
-
-       port->port->rphy = NULL;
-
 }

 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index d3c5297c6c89..9a25ae3a52a4 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -219,7 +219,6 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)

        if (port->num_phys == 1) {
                sas_unregister_domain_devices(port, gone);
-               sas_port_delete(port->port);
                port->port = NULL;
        } else {
                sas_port_delete_phy(port->port, phy->phy);
