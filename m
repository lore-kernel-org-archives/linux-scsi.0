From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 12:33:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204101219250.78463-100000@beppo>
References: <OFDDCB335C.1A38AFF1-ONC1256B97.00555052@de.ibm.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OFDDCB335C.1A38AFF1-ONC1256B97.00555052@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@DE.IBM.COM>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org


> If there are cases which require WWNN+WWPN to identify a FC port then a
> you would need this pair to query a FC ports D_ID. I wonder why this is
> not reflected in the FC name server specification, FC-GS-3, (see GID_PN
> for example).

Good question.

But I believe that in sending a CT frame to the name server with PortID XXXXXX
to ask it what the Port Name is or the Node Name, all you're doing is to ask
it to use that PortID as a search key and return the Port Name. This hasn't
got all that much to do with initiators needing to use WWNN+WWPN (currently
bound with D_ID such and such) to uniquely, and persistently, identify a
device.

I mean, to use FC-GS-2 or FC-GS-3, you do something like

GID_FT
(gimme a list of Port IDs on the fabric for the FC4 type I want to know about)

For each member of the returned list do:

	GPN_ID (get it's port name)

	GNN_ID (get it's node name)

	optionally: GFF_ID (get it's FC4 features. For FC-SCSI this gets
	you Initiator/Target support roles)

You would think that there would be one CT command to return *both* Port and
Node names- and there is (it's part of the return data at least for GA_NXT).

It's my ill informed opinion that this design is a result of a difference of
opinion about the usages of WWPN/WWNN within the t10 committee. I believe I've
heard one of the members expresss regret over having separate numbers.


Be that as it may be, we *know* we have cases where you *must* use both the
WWNN and WWPN to *uniquely* ID the device. If I have just about any FC disk
drive, it is going to have a common WWNN but different WWPNs depending on
whether you talk to it via FC_AL Port A or Port B connections. If I have the
drive in a JMR JBOD with both Port A and Port B connectors, and connect both
to HBAs from a system (e.g., to provide warm failover), I really need *both*
WWPN and WWNN to keep track of which drive is which drive.

I *might* want to treat them as the same (e.g., for transparent failover), but
this should be under control, not happenstance depending on whether I decide
to use just one of WWNN or WWPN to ID devices.

-matt


