From: Berkley Shands <berkley@cs.wustl.edu>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple map/unmaps
Date: Mon, 5 Jan 2004 13:29:54 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200401051929.i05JTsM0000014248@mudpuddle.cs.wustl.edu>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: davem@redhat.com, gibbs@scsiguy.com
Cc: berkley@cs.wustl.edu, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

	The pci layer is modifying the sg list, and then placing a zero
in the length field. pci-gart.c at line 453 (2.6.0 sources) checks this length field
after a retry, sees that it is zero, and bughalts.
	As Justin points out, SOMEBODY needs to reset the sg list, or kick the error
back up far enough to recreate it completely. Or just don't bother to
combine the entries. A machine with 8GB or more can stand to lose a few bytes.
How many hardware devices can handle a 1MB+ I/O buffer being passed to them anyway?

berkley
