From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: Kernel Crash when using the open-iscsi initiator on 2.6.25.6
Date: Wed, 25 Jun 2008 11:54:41 -0500
Message-ID: <48627851.9010804@cs.wisc.edu>
References: <81083a450806242236m62754185t3099c06f9f77676@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <81083a450806242236m62754185t3099c06f9f77676-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi-help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi-unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Ashutosh Naik <ashutosh.naik-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Ashutosh Naik wrote:
> Please find the kernel log attached. I was using the open-iscsi
> initiator on kernel 2.6.25.6 with a chelsio iSCSI target and the crash
> happened on the initiator machine.
> 
>  connection5:0: ping timeout of 5 secs expired, last rx 4309640121,
> last ping 4309645121, now 4309650121
>  connection5:0: detected conn error (1011)

This happens when we cannot reach the target for the noop timout and 
interval seconds, which can happen if a cable is unplugged or the 
network is not reach able or is dropping packets.


>  connection5:0: ping timeout of 5 secs expired, last rx 4309652882,
> last ping 4309657882, now 4309662882


However, once it happens we should not report it again like is done 
here. There is something weird there. Do you have the iscsid output? 
Between these two reports of pings timing out is there any messages from 
iscsid about reconnecting?

>  connection5:0: detected conn error (1011)
>  connection5:0: detected conn error (1011)
>  session5: host reset succeeded


And we should not get here. The iscsi driver's scsi command timeout 
handler should prevent the command from firing the scsi eh, because in 
this case we think it is a transport problem.

What version of the iscsi tools are you using? Are they from a distro or 
open-iscsi.org?

Are you running with the iscsi kernel modules from 2.6.25.6, or are you 
using the iscsi modules from the open-iscsi.org website that come with 
the tarball?

Is the kernel a unmodified 2.6.25.6 or does it have some distro patches 
or patches that you have created?


> INFO: task fdisk:5226 blocked for more than 120 seconds.

I think you get this message and what follows, is a result of the above 
problem. While the iscsi initiator is trying to reconnect, IO is queued 
by the scsi layer so fdisk is going to be waiting around until we 
recover or give up.
