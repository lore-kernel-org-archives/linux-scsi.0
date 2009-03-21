From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Sat, 21 Mar 2009 16:03:03 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E02B4B4A2@HQ-EXCH-5.corp.brocade.com>
References: <200903142003.n2EK39r4031547@blc-10-6.brocade.com> <49C27E95.4050401@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755574AbZCUXEX@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <49C27E95.4050401@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Bottomley@HansenPartnership.com, Krishna Gudipati <kgudipat@Brocade.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>
List-Id: linux-scsi@vger.kernel.org

> some quick general comments:
> 
> - Patch needs to be run through checkpatch.pl again.
> - If you are not implementing a callout like issue_lip then you do not
> need to implement a function that does nothing.
> - Remove the OS compat stuff that just calls right into the linux
> function. For example kill bfad_os_pci_probe.
> 

We will fix all he checkpatch issues and make necessary cleanups and
resubmit soon.

> > +
> > +	im_port->shost->hostdata[0] = (unsigned long)im_port;
> 
> 
> 
> I think I asked about this before. Why do you just not allocate the
bfad
> or im_port in the hostdata? What is the struct hierarchy? Do you have
> one bfad for the entire HBA/pci_device then have a im_port for each
port
> on the hba?
> 

Thanks for review the code again. Yes, we have one bfad for each HBA
port/pci device, and one im_port (im stands for initiator mode) for each
scsi_host/vport. We can certainly allocate im_port in scsi_host_alloc()
as you suggest, but currently we allocate all possible fc4 port
(initiator/tgt/ipfc) in one function, and it is just more convenient to
do it in one place.

Thanks

Jing
 
