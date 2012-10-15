From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/10] scsi: avoid linebreaks in syslog output
Date: Sun, 14 Oct 2012 20:19:27 -0400
Message-ID: <CAMM=eLfLq3sqm4hkiCAqB2m75+1UN+3O0pvYMOES-xHT9PHiwA@mail.gmail.com>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36801 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2JOATt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2012 20:19:49 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so3026834lag.19
        for <linux-scsi@vger.kernel.org>; Sun, 14 Oct 2012 17:19:48 -0700 (PDT)
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Fri, Oct 12, 2012 at 4:33 AM, Hannes Reinecke <hare@suse.de> wrote:
> This patchset updates the SCSI midlayer to use dev_printk() instead
> of the simple printk(). The main objective here is to avoid line-breaks
> in syslog output; with the current state it's nearly impossible to match
> the output to the occurring device; under high load even the CDB will
> be split off into individual bytes, spread randomly across the lines.
> Which makes debugging via scsi_logging_level _really_ hard.
> In addition we'll be getting the syslog messages nicely prefixed with
> the device, which will make userspace logging daemons happy.
>
> Before:
> [  297.300605] sd 2:0:3:2: Send:
> [  297.300607] 0xffff8802348b0980
> [  297.300610] sd 2:0:3:2: CDB:
> [  297.300615] Test Unit Ready: 00 00 00 00 00 00
> [  297.300747] sd 2:0:3:2: Done:
> [  297.300750] 0xffff8802348b0980 SUCCESS
> [  297.300753] sd 2:0:3:2:
> [  297.300755] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [  297.300758] sd 2:0:3:2: CDB:
> [  297.300764] Test Unit Ready: 00 00 00 00 00 00
> [  297.300766] sd 2:0:3:2:
> [  297.300769] Sense Key : Unit Attention [current]
> [  297.300771] Info fld=0x0
> [  297.300772] sd 2:0:3:2:
> [  297.300776] Add. Sense: Capacity data has changed
>
> After:
> [  636.683556] sd 2:0:3:2: Send: 0xffff88043145eec0
> [  636.727856] sd 2:0:3:2: CDB: Test Unit Ready: 00 00 00 00 00 00
> [  636.785330] sd 2:0:3:2: Done: 0xffff88043145eec0 SUCCESS
> [  636.838228] sd 2:0:3:2: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [  636.899099] sd 2:0:3:2: CDB: Test Unit Ready: 00 00 00 00 00 00
> [  636.955905] sd 2:0:3:2: Sense Key : Unit Attention [current]
> [  637.069179] sd 2:0:3:2: Add. Sense: Capacity data has changed

I know there are a lot of changes here but shouldn't all this get
fixed in stable 3.5+?

Thanks for sorting all this out Hannes.
