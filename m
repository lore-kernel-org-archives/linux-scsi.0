From: <random1@o-o.yi.org>
Subject: aic7xxx dump_card_state not reentrant?
Date: 17 Aug 2002 12:05:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <uwuqp79nn.fsf@o-o.yi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from list by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 17g64Q-0001Z6-00
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2002 18:04:58 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'm trying to get suspend and resume working for a 2.4 kernel with
scsi devices, and I'm running into trouble saving and restoring the
card state.  One thing that I've discovered in the process of looking
into this is that the ahc_dump_card_state routine is called at both
process level and interrupt level.  If I read it correctly, it alters
the card state while dumping the list of SCBs.  If a sequencer
interrupt occurs in the meantime, bad stuff happens.  Doesn't it?
Well, I'm seeing panics in which ahc_dump_card_state is running in
both contexts "simultaneously."




