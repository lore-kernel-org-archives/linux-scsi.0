From: linuxscsi <linuxscsi@4bridgeworks.com>
Subject: Inquiry data buffer corruption during domain validation with SYM5
	3c8xx_2 driver
Date: Tue, 30 Nov 2004 18:47:32 -0000
Message-ID: <C18BA5DDB58DD511BD0700C0DF0DD4501EEC83@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.digitalinterfacesltd.com ([62.69.87.37]:5393 "EHLO
	ntserver4.diluk.co.uk") by vger.kernel.org with ESMTP
	id S262265AbUK3Sri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 13:47:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

We have a device on test from a customer, a SCSI-FC bridge allowing an FC
device to be connected to a SCSI HBA, that is highlighting some form of data
issue during domain validation. The device itself is behaving badly wrt the
inquiry command _but_ we don't believe this should cause a problem due to
the way the inquiry command data buffers are initialised and compared.
However there is a problem with data corruption somewhere and this is
causing "Domain Validation Initial Inquiry Failed" messages. Looks like data
is being corrupted somewhere either in the driver or on its way back from
the driver - maybe in a buffer copy.

During the initial inquiry compare, in spi_dv_device_compare_inquiry (in
scsi_transport_spi.c), the inquiry data buffer is initialised to all zeroes,
an inquiry command is executed and data loaded into the buffer. This is then
repeated with a second buffer initialised to all zeroes, a second inquiry
command exectuted with data loaded into the second buffer. The two buffers
are then compared. I would not expect a problem however there are data
errors.

What we have found is that the initial inquiry data indicates there is 144
bytes of inquiry data. Inquiry commands after the first are then requesting
144 bytes - but the device is only returning 64 bytes. This in itself should
not cause a problem. If the buffers receiving the data are initialised to
zeroes and are only loaded with 64 bytes the buffers should compare - 64
bytes of data and 80 bytes of zeroes - 144 bytes total. The problem occurs
however because the data buffers receiving the inquiry data are being loaded
with the 64 bytes of inquiry data and the remaining 80 bytes are being
overwritten with other data from somewhere - from where I cannot yet find.

There appears two possible causes. 

1. First the sym53c8xx driver is writing bad data into the buffers - 64
bytes of valid inquiry data and upto a further 80 bytes of rubbish - I find
that almost, but not totally, impossible to believe especially as the
sym53c8xx driver indicates the correct residue. 

2. Alternatively the sym53c8xx driver could be writing the inquiry data into
a temporary, uninitialised buffer which is being copied to the buffer set up
in spi_dv_device_compare_inquiry. If different inquiry commands use
different temporary buffers then the different temp buffers would be loaded
with the 64 bytes of valid inquiry data and be left with different
remainders each of 80 bytes of rubbish.

Can anyone tell me if temporary buffers are used? I have spent a load of
time looking through the code, adding print statements to display buffer
contents at various places, using an analyser on the scsi bus, etc. and
can't find anything so far. 

Whatever is happening it seems pretty pointless to initialise buffers if
something is going to write back rubbish into them and not just what is
returned by the scsi command. When I initialise a buffer and then only write
part of it I expect the remainder to be unchanged.
 
Richard




Bridgeworks Ltd
135 Somerford Road,
Christchurch
Dorset, BH23 3PY
England.

Tel 0870 121 0708
Fax 0870 121 0709

Email: richardw@4bridgeworks.com

