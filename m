From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 20 May 2008 10:30:45 -0700
Message-ID: <20080520103045.2bb0a033.akpm@linux-foundation.org>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	<20080520030232.fc91b64e.akpm@linux-foundation.org>
	<a8e1da0805200405t10fae448w589449e75a5abec6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780AbYETRat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 13:30:49 -0400
In-Reply-To: <a8e1da0805200405t10fae448w589449e75a5abec6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 20 May 2008 19:05:21 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Tue, May 20, 2008 at 6:02 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> >> Converting class semaphore to mutex cause lockdep warnings due to
> >> class_interface_register/unregister will possible call device_add/del
> >
> > Shouldn't we just fix that?
> 
> Andrew, could you tell more?

Well what are these lockdep warnings?  Normally such a warning means that
we have a locking bug. I _assume_ that you've determined that the warnings
are false-positives?

The warning which Mariusz Kozlowski discovered ("Subject: Re:
2.6.26-rc2-mm1: possible circular locking dependency detected") was
triggered by the "class semaphore to mutex" conversion and it looks
like a real bug to me.  Would your patch prevent warnings such as that
one from being available to us?

