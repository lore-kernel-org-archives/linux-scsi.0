From: kuznet@ms2.inr.ac.ru
Subject: Re: softscsi patch
Date: Fri, 5 Jul 2002 18:53:07 +0400 (MSD)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207051453.SAA05954@sex.inr.ac.ru>
References: <20020630222043.B29045@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020630222043.B29045@parcelfarce.linux.theplanet.co.uk> from "Matthew Wilcox" at Jun 30, 2 10:20:43 pm
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, davem@redhat.com

Hello!

> This work shows up a hole in the current softirq API -- there's no support
> for unregistering a softirq (close_softirq or similar).  We should do
> this in scsi_exit -- make sure no softirqs are running while we unload.
> This probably isn't a problem in practice, but it'd be nice to fix it.

Well, it was difficult to make not introducing interaction between
cpus (which was main goal of softirq core).

I think it is possible using ideas sort of brlock or using detection
of quiescent intervals introduced with RCU. Anyway, I still do not see
how to make this in clean way.

BTW are you sure that scsi layer really needs bare softirq?
Networking is very special in this sense, with local traffic
the first spinlock is hit at socket level (very high granularity!).
However, even in this case we are switching to tasklets (NAPI uses
per-device tasklet in fact). Maybe, scsi will feel better with
per-controller tasklets too.

Alexey
