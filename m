From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/6] block: push down BKL into .locked_ioctl
Date: Sun, 4 Jul 2010 22:59:38 +0200
Message-ID: <201007042259.38633.arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-2-git-send-email-arnd@arndb.de> <20100704073050.GA31823@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100704073050.GA31823@merkur.ravnborg.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday 04 July 2010 09:30:50 Sam Ravnborg wrote:
> >  	default:
> >  		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
> > -		return -ENOTTY;
> > +		ret = -ENOTTY;
> >  	}
> > +	unlock_kernel();
> >  
> >  	return 0;
> >  }
> You are loosing the return result here in the two error situations above.
> Initialise ret to 0 and return ret seems the easy way to do it.
> 
> The rest looked ok - I only looked at the patches.

Good catch, thanks!

I've updated the patch and pushed it out to my git tree.

	Arnd
