From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Date: Thu, 13 May 2010 20:25:39 +0200
Message-ID: <4BEC4423.3030507@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org> <1273766778.4353.200.camel@mulgrave.site> <4BEC272E.10508@kernel.org> <20100513174047.GX25951@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100513174047.GX25951@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

Hello,

On 05/13/2010 07:40 PM, Jens Axboe wrote:
> Is there a valid case for setting the capacity less than the unlocked
> capacity? I would think the unlock/lock bool api is saner.

IDE currently is the only user (and probably has been that way the
whole time), so it is a binary thing.  I have no idea why the original
interface was designed that way.  Looks like it tried to be too
generic.  Anyways, for the task at hand, the following should be
enough.

	void (*unlock_native_capacity)(void);

This simple signalling is how the current interface is being used
anyway.  If nobody objects, I'll replace ->set_capacity() with the
above.

Thanks.

-- 
tejun
