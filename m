From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI: Fix hard lockup in scsi_remove_target()
Date: Fri, 2 Oct 2015 06:16:17 -0700
Message-ID: <20151002131617.GA13860@infradead.org>
References: <1443774062-15638-1-git-send-email-jthumshirn@suse.de>
 <20151002124903.GA11987@infradead.org>
 <mqdoagh5sdu.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <mqdoagh5sdu.fsf@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 02, 2015 at 03:09:33PM +0200, Johannes Thumshirn wrote:
> Having the list_move() outside of the host_lock was purely by
> accident. Interestingly the stressing didn't mind it. But yes you're
> right, __scsi_remove_target() should be made host_lock() save for being
> called under the host_lock.
> 
> Regarding the list move, does it look OK for you (i.e. do we still need
> it after reworking __scsi_remove_target())? IMHO yes, but I only have
> half a year of experience in this area).

Hi Johannes,

your general approach looks fine, we just need to fix up the locking as
far as I can tell.
