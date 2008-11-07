From: Chris Mason <chris.mason@oracle.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 12:22:15 -0500
Message-ID: <1226078535.15281.63.camel@think.oraclecorp.com>
References: <4913028B.6010405@redhat.com>
	 <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk>
	 <1226072970.15281.46.camel@think.oraclecorp.com>
	 <yq1r65na5ll.fsf@sermon.lab.mkp.net>
	 <1226074002.8030.33.camel@localhost.localdomain>
	 <1226074270.15281.50.camel@think.oraclecorp.com>
	 <1226074710.8030.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1226074710.8030.43.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-11-07 at 10:18 -0600, James Bottomley wrote:
> On Fri, 2008-11-07 at 11:11 -0500, Chris Mason wrote:

[ complex trim management code ]

> > 
> > It doesn't seem like a good idea to maintain a ton of code that gets
> > exercised so rarely, especially wrt filesystem crashes.
> 
> Heh, am I the only person here who deletes files on a regular basis
> (principally to get my disk down from 99%)?

Using it is easy, but the failure case is the storage forgets about a
block the FS cares about, so actually testing the code means we have to
test all the blocks allocated to the FS to make sure they have the
correct values.  Given remapping and everything else we've talked about,
any block in the FS could become corrupt due to a trim bug on block X.

So, trim bugs will look like a dozen other bugs, and they may not get
reported for months after the actual bug was triggered (all things I
know you already know ;)

I think the bar for keeping it simple is much higher here than in other
parts of the storage stack.

-chris


