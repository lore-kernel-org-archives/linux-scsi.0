From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Date: Thu, 13 May 2010 11:06:18 -0500
Message-ID: <1273766778.4353.200.camel@mulgrave.site>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273766206-17402-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-05-13 at 17:56 +0200, Tejun Heo wrote:
> Hello, Jens, James, Jeff,
> 
> This patchset implements ->set_capacity() in libata so that HPA can be
> unlocked on demand.
> 
>  0001-block-restart-partition-scan-after-resizing-a-device.patch
>  0002-SCSI-implement-sd_set_capacity.patch
>  0003-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
>  0004-libata-implement-on-demand-HPA-unlocking.patch
> 
> 0001 makes partition scan code to restart after ->set_capacity().
> This makes sure that partitions which start beyond the HPA limit are
> discovered.
> 
> 0002 implements ->set_capacity() in sd.
> 
> 0003 makes libata accept device capacity larger than the initial one.
> 
> 0004 implements ->set_capacity() in libata which asks libata EH to
> unlock HPA, waits and returns the new capacity.
> 
> Ben Hutchings suggeseted implementing ->set_capacity() in libata and
> also reported the bug in the current partition scan code where it
> fails to discover partitions which start beyond the HPA limit.
> 
> Unlocking HPA on-demand seems to be the safest default way to deal
> with HPA.  Leaving HPA alone by default could fail to detect or
> truncate existing partitions while unlocking by default make it more
> prone to obscure data corruptions when combined with BIOSes beliving
> that they exclusively own the area beyond HPA limit.
> 
> 0001 should be routed through the block tree.  0002 should go through
> SCSI but given the dependency and that libata is the only user, it
> would probably much easier to route it through libata-dev#upstream
> together with 0003 and 0004.

I'm not sure this is such a good interface ... it sounds very error
prone for what is effectively a binary lock/unlock.  Instead of just
saying unlock the HPA and show me the new capacity (with a rescan), you
have to echo the right number of sectors to the set_capacity variable.
Isn't a hpa_unlock libata specific attribute better (you could even call
BLKRRPART from the user context of the write)?

James


