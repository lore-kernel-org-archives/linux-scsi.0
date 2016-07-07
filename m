From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: how to test pscsi with vhost
Date: Thu, 7 Jul 2016 18:23:32 +0800
Message-ID: <CAMj5BkgHaDcj_ZL8_RkwLORfSabth1jSJ26i0sZnR-ngXaSgMw@mail.gmail.com>
References: <CAMj5BkgpyoBY0GLoqbDdOa5LeYXsWNVxQUBRaH3AYgERzP-VMw@mail.gmail.com>
 <37b51089-f884-664e-b7d0-2ffdedde462d@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:35835 "EHLO
	mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbcGGKXd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2016 06:23:33 -0400
Received: by mail-qt0-f175.google.com with SMTP id f89so5981194qtd.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jul 2016 03:23:33 -0700 (PDT)
In-Reply-To: <37b51089-f884-664e-b7d0-2ffdedde462d@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhu Lingshan <lszhu@suse.com>
Cc: linux-scsi@vger.kernel.org

Hi, Lingshan

On Mon, Jul 4, 2016 at 10:02 PM, Zhu Lingshan <lszhu@suse.com> wrote:
> Hi Zhangfei,
>
> I am also interested in pscsi, you can try kvm, seems you can create a
> virtualized pscsi device in kvm / virt-manager. I haven't tried that yet,
> hope this can help.
>


Somehow I failed to setup virt-manager

error like:
Failed to connect to Mir: Failed to connect to server socket: No such
file or directory
Unable to init server: Could not connect: Connection refused

(virt-manager:6661): Gtk-CRITICAL **: gtk_settings_get_for_screen:
assertion 'GDK_IS_SCREEN (screen)' failed


Still in check with qemu.
The issue is scsi_probe_lun can not get correct lun.
Have hacked with scsi_execute_req INQUIRY sereral times but same result.

sc->result=0x8000000
sc->sense_buffer[0]=0x0

after targetcli setup, we can get:
[  104.238740] PSCSI[0]: Referencing SCSI Host ID: 1
[  104.243471] PSCSI[0]: Referencing SCSI Channel ID: 0
[  104.248463] PSCSI[0]: Referencing SCSI Target ID: 1
[  104.253368] PSCSI[0]: Referencing SCSI LUN ID: 0

pscsi_show_configfs_dev_params SCSI Device Bus Location: Channel ID: 0
Target ID: 1 LUN: 0 Host ID: 1
Vendor: HGST     Model: HUSMM1640ASS204  Rev: C2D0

Suppose drivers/scsi/virtio_scsi.c &
drivers/target/target_core_pscsi.c have been verified.
Suspect sas driver itself need do something to support pscsi.

Still not find the root cause.

Thanks
