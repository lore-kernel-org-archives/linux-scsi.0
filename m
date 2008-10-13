From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] mptsas: remove pointless null check
Date: Mon, 13 Oct 2008 15:37:01 +0100
Message-ID: <20081013153701.61f22485@lxorguk.ukuu.org.uk>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	<48F2F138.6020103@kernel.org>
	<48F34CB9.3020000@pobox.com>
	<20081013150529.75f22702@lxorguk.ukuu.org.uk>
	<1223907778.5566.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1223907778.5566.3.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> If I remember rightly this check is necessary because phy_info can be
> NULL in certain situations.  Your patch will trip this to oops.  What

In which case it will already have crashed

> your description needs to say is that we no longer need to check this
> pointer for NULL because it was checked somewhere else in the stack ...
> but I can't see where that is, where is it?

We don't check: but if it was NULL we then fall straight through and
dereference it unconditionally... so either its a wrong NULL check and
the old code oopses (which a trawl says it doesn't) or the check is bogus.

Alan
