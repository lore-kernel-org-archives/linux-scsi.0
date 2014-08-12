From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Date: Mon, 11 Aug 2014 23:31:26 -0700
Message-ID: <20140812063126.GA9075@roeck-us.net>
References: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140812060153.GB13231@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140812060153.GB13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sanjeev Sharma <sanjeev_sharma@mentor.com>, hdegoede@redhat.com, kraxel@redhat.com, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 12, 2014 at 02:01:53PM +0800, Greg KH wrote:
> On Tue, Aug 12, 2014 at 11:38:37AM +0530, Sanjeev Sharma wrote:
> > spin_is_locked() always return false in uniprocessor configuration and therefore it
> > would be advise to replace with lockdep_assert_held().
> 
> Add "on some architectures" in here somewhere, as it's not broken on the
> large majority of UP cpus :)
> 
FWIW, it is confirmed broken on mips (32 and 64 bit), ppc, and sparc64.
I have not tested on x86. Might be worth trying. arm64 seems to be ok,
unless I did something wrong in my test, as well as at least some of
the architectures which don't support smp to start with (such as sparc32
or microblaze).

Guenter
