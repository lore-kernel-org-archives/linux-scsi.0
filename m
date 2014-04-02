From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/4] target/core: T10-Dif: check HW support capabilities
Date: Wed, 02 Apr 2014 11:47:02 -0700
Message-ID: <1396464422.7627.22.camel@haakon3.risingtidesystems.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
	 <1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>
	 <53360E54.5060004@mellanox.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CE87D7@avmb2.qlogic.org>
	 <533620C0.9060903@mellanox.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CE9B32@avmb2.qlogic.org>
	 <1396315146.22665.82.camel@haakon3.risingtidesystems.com>
	 <533A71E9.90308@dev.mellanox.co.il> <yq1k3b9x9gu.fsf@sermon.lab.mkp.net>
	 <533AF70F.4060003@mellanox.com>
	 <1396374354.18589.13.camel@haakon3.risingtidesystems.com>
	 <533BF7EF.2080609@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <533BF7EF.2080609@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: sagi grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Quinn Tran <quinn.tran@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-04-02 at 14:43 +0300, sagi grimberg wrote:
> On 4/1/2014 8:45 PM, Nicholas A. Bellinger wrote:
> > On Tue, 2014-04-01 at 20:27 +0300, sagi grimberg wrote:
> >> On 4/1/2014 8:09 PM, Martin K. Petersen wrote:
> >>>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
> >>> Sagi> I originally wrote the code to support that. But it got left
> >>> Sagi> behind since I figured it is not an interesting use-case.  If your
> >>> Sagi> beckend doesn't support T10-PI why should the target publish it
> >>> Sagi> support it and ask the device to strip/insert it?  I suppose it is
> >>> Sagi> to allow the initiator to protect half-way, but I don't know how
> >>> Sagi> interesting it is if the data is not stored with protection...
> >>>
> >>> That depends what you do on the backend. There are several devices out
> >>> there that expose PI to the host but use a different protection scheme
> >>> internally. And then synthesize PI on the host-facing side. Some even do
> >>> T10 PI to an internal protection scheme and then back to T10 PI when
> >>> talking to the disk drives in the back end.
> >>>
> >> Hey Martin,
> >>
> >> I understand, but even for internal different T10-PI schemes, is
> >> stripping protection from incoming data
> >> at the fabric level (and then do whatever with it in the backend level)
> >> the right thing to do here?
> >> I mean we basically lose protection across the PCI with this scheme
> >> aren't we?
> >>
> > The WRITE_STRIP + READ_INSERT case would be still be useful for IBLOCK
> > backends that don't support real hw PI, so that at least the protection
> > can be in place for data movement between physical machines.
> >
> > Also, I think the amount of changes required to support this type of
> > configuration in target-core are quite small.
> 
> Not sure I understood your intention here.
> Do you mean that the backstore doesn't support T10-PI, the transport 
> support T10-PI and target publish to fabric that it support T10-PI?
> This will lead to the DIN_INSERT/DOUT_STRIP you are referring to right?

Correct.

> Is there any value to publish the fabric PI support if your backing 
> device doesn't support it?

So yes, I think there is value is allowing a transport to publish PI
support for a device, even when the backend does not support it.

In terms of the possibilities for data corruption, moving payloads
between physical hosts would certainly have a higher potential given the
complexity and number of overall components involved in the transaction.

If all unprotected devices should report PI (by default) when the
transport supports it is a separate question..  ;)

> 
> The opposite case (backstore support, transport no support) it makes 
> sense to NOT publish support and do half-way protection in SW
> (the backstore is formatted with PI).
> 

Correct.

--nab
