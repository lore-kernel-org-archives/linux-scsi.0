From: Tim Pepper <tpepper@gmail.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Tue, 12 Oct 2004 09:31:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <eada2a070410120931714d28c1@mail.gmail.com>
References: <20041012000058.GA26569@osdl.org>
	 <eada2a07041012092973d35415@mail.gmail.com>
Reply-To: Tim Pepper <tpepper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.197]:59941 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S266195AbUJLQbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 12:31:08 -0400
Received: by mproxy.gmail.com with SMTP id 80so202332rnk
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2004 09:31:06 -0700 (PDT)
In-Reply-To: <eada2a07041012092973d35415@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, 11 Oct 2004 17:00:58 -0700, Dave Olien <dmo@osdl.org> wrote:
> I'm having some odd behavior with my multipath fibre channel system.
> I'm running 2.6.9-rc3, and have a Qlogic 2300 dual ported controller,
> routed through two brocade switches to two IBM FastT200 disk arrays.
>
> The FastT200 are configured as JBOD. Each array has 10 disks.  Each FastT200
> is dual ported, configured in "active-active" mode.

I thought on FAStT's while there are dual-active controllers, for a
given lun they weren't active-active, but rather active-passive with
either manual or automatic volume transfer.  Assuming automatic volume
transfer is on and you send IOs to both controllers simultaneously you
would ping-pong the cache, drive IO rates lower and possibly see that
manifest itself in interesting behaviour in the linux scsi stack.
With manual volume transfer you should get IO errors from the
controller which is not active or preferred for the given lun.  Maybe
somebody involved with their RDAC multipathing driver follows this
list and can comment on their intentions for the 2.6 kernel and dm
multipathing.
