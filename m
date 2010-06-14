From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.34 PDC20268 PATA IO error loop makes system unusable
Date: Mon, 14 Jun 2010 12:17:53 +0100
Message-ID: <20100614121753.5723eaa2@lxorguk.ukuu.org.uk>
References: <20100613154808.GA10408@basil.fritz.box>
	<4C15DDA0.3020409@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C15DDA0.3020409@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > sd 11:0:0:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > sd 11:0:0:0: [sdd] Sense Key : Medium Error [current] [descriptor]

That is the drive complaining about a bad block.

> > Descriptor sense data with sense descriptors (in hex):
> >        72 03 13 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
> >        00 5b 23 bb 
> > sd 11:0:0:0: [sdd] Add. Sense: Address mark not found for data field
> > sd 11:0:0:0: [sdd] CDB: Read(10): 28 00 00 5b 23 4f 00 00 80 00

Which in my experience usually comes from

- The disc being unable to find the data block

- A corrupt indirect block in the file system leading to a requst for an
  out of range data block

In theory it could be an on the wire bitflip but thats a bit too
consistent to believe.

Alan
