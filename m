From: Matthew Jacob <mjacob@feral.com>
Subject: Re: 2.5.63-mm2
Date: Wed, 5 Mar 2003 23:38:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305233253.P20267@mailhost.quaver.net>
References: <20030302180959.3c9c437a.akpm@digeo.com> <1046815078.12931.79.camel@ibm-b>
 <20030304234042.2553deed.akpm@digeo.com> <20030305173854.GA1090@beaverton.ibm.com>
 <20030305185231.GE1090@beaverton.ibm.com> <20030305133305.A16075@beaverton.ibm.com>
Reply-To: mjacob@quaver.net
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030305133305.A16075@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Morton <akpm@digeo.com>, Mark Wong <markw@osdl.org>, linux-scsi@vger.kernel.org

> Though I still do not know why the feral gets a time out but qlogicisp
> does not. It is apparently a read that times out while mounting root for
> the first time (readonly), so this is not the first read sent to the drive

The command in question that's timing out is "ABOUT FIRMWARE".

If at reset you see the pattern "ISP " in mailbox registers 1, 2, 3
you're supposed to be at the hard PROM- i.e., no firmware has been
loaded and set running by system boot procedures. Unfortunately you get
some platforms where if this is not set this means that the card is
neither in hard reset state (i.e., running out of it's prom) nor
actually running f/w. Hence the timeout on the command.

I've always considered this a relatively minor buglet as it doesn't
occur on *that* many systems but I should probably fix it.

-matt



