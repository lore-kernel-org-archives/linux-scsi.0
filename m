From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx dump_card_state not reentrant?
Date: Sat, 17 Aug 2002 13:54:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3520000.1029614064@aslan.scsiguy.com>
References: <uwuqp79nn.fsf@o-o.yi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <uwuqp79nn.fsf@o-o.yi.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: random1@o-o.yi.org, linux-scsi@vger.kernel.org

> I'm trying to get suspend and resume working for a 2.4 kernel with
> scsi devices, and I'm running into trouble saving and restoring the
> card state.  One thing that I've discovered in the process of looking
> into this is that the ahc_dump_card_state routine is called at both
> process level and interrupt level.  If I read it correctly, it alters
> the card state while dumping the list of SCBs.  If a sequencer
> interrupt occurs in the meantime, bad stuff happens.  Doesn't it?
> Well, I'm seeing panics in which ahc_dump_card_state is running in
> both contexts "simultaneously."

You must hold the ahc_lock() before calling most routines in the driver.
It is tha ahc_lock() that protects against reentrancy.

--
Justin

