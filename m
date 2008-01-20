From: Grant Grundler <grundler-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Subject: Re: udev hangs USB-storage (HP r707 camera)
Date: Sat, 19 Jan 2008 20:12:58 -0700
Message-ID: <20080120031258.GJ11553@colo.lackof.org>
References: <20080119174556.GE11553@colo.lackof.org> <47929B9F.8080607@s5r6.in-berlin.de> <20080120022829.GG11553@colo.lackof.org> <1200797791.11214.3.camel@localhost.localdomain> <20080120031008.GI11553@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080120031008.GI11553-lGaJ6EKWmV+kGg0756fqLw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 19, 2008 at 08:10:08PM -0700, Grant Grundler wrote:
> root@mb500:~ # strace -o strace-dd-HPr707.out dd if=/dev/sda of=/dev/null skip=60800 count=1
> dd: reading `/dev/sda': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 55.7303 seconds, 0.0 kB/s

BTW, here's the relevant bit of the strace output:
open("/dev/sda", O_RDONLY|O_LARGEFILE)  = 0
_llseek(0, 0, [0], SEEK_CUR)            = 0
close(1)                                = 0
open("/dev/null", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 1
rt_sigaction(SIGUSR1, NULL, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
rt_sigaction(SIGUSR1, {0x80493a0, [INT USR1], 0}, NULL, 8) = 0
rt_sigaction(SIGINT, {0x8049390, [INT USR1], SA_NOMASK|SA_ONESHOT}, NULL, 8) = 0
clock_gettime(CLOCK_MONOTONIC, {70667, 216812381}) = 0
ioctl(0, MGSL_IOCSTXIDLE or MTIOCGET or SNDCTL_MIDI_MPUCMD, 0xbf8e31d0) = -1 EIN
VAL (Invalid argument)
_llseek(0, 31129600, [31129600], SEEK_CUR) = 0
read(0, 0x8059000, 512)                 = -1 EIO (Input/output error)

thanks,
grant
