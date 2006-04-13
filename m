From: Douglas Gilbert <dougg@torque.net>
Subject: Re: HBA self selection
Date: Thu, 13 Apr 2006 13:58:25 -0400
Message-ID: <443E9141.6030901@torque.net>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from simmts8.bellnexxia.net ([206.47.199.166]:61433 "EHLO
	simmts8-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S932114AbWDMR6b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 13:58:31 -0400
In-Reply-To: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: linux-scsi@vger.kernel.org

Cameron, Steve wrote:
> Noticed in scsi_scan.c (2.6.15.2 kernel...)
> 
>    1336 static void __scsi_scan_target(struct device *parent, unsigned int chann        el,
>    1337                 unsigned int id, unsigned int lun, int rescan)
>    1338 {
>    1339         struct Scsi_Host *shost = dev_to_shost(parent);
>    1340         int bflags = 0;
>    1341         int res;
>    1342         struct scsi_target *starget;
>    1343
>    1344         if (shost->this_id == id)
>    1345                 /*
>    1346                  * Don't scan the host adapter
>    1347                  */
>    1348                 return;
>    1349
> 
> There exist some target devices which depend on the adapter being
> able to do self selection.  The HP MSA30 presents a processor device
> at ID 7, for instance.
> 
> The processor device at ID 7 will generally not be accessible, because
> the HBA is generally at this ID.  The processor device doesn't care that the
> HBA is at id 7.  He says, "hmm, the adapter is talking to himself,
> that means, he's talking to me."   It's just a way to put a processor
> device on the bus without really "using up" a scsi id, since there
> are only a few of them.
> 
> This used to work, I'm pretty sure.  Could do 
> "echo scsi add-single-device 0 0 7 0 > /proc/scsi/scsi" and 
> the processor device would show up.  Now it doesn't.

Steve,
I suppose the lk 2.6 equivalent of:
# echo "0 7 0" > /sys/class/scsi_host/host<n>/scan
doesn't work either? [The reason I ask is that the
new technique works for finding "well known" lus.]

Doug Gilbert

