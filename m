From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: 2.6: how do I this in sysfs?
Date: Mon, 29 Aug 2005 12:24:18 -0500
Message-ID: <D4CFB69C345C394284E4B78B876C1CF10ABB0269@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:23735 "EHLO
	ccerelbas02.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751142AbVH2RZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2005 13:25:11 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, mochel@osdl.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, Luben Tuikov <luben_tuikov@adaptec.com>


> This is after my minimal sas transport class, please also 
> read the thread about it on linux-scsi
> 
In the referenced code for using sysfs, there only appear to be methods
for reading attributes.  How about if we want to cause a command to
get written out to the hardware?   Do we do something like this?

        /* get a semaphore keep everyone else out while we're working,
           and hope like hell that all the other processes are playing
           nice and using the semaphore too, or else we're hosed. */

        get_some_kind_of_semaphore();

        fd = open("/sys/blah/blah/attribute1", O_RDWR);
        write(fd, SOME_JUNK1, sizeof(SOME_JUNK1));
        close(fd);
        fd = open("/sys/blah/blah/attribute2", O_RDWR);
        write(fd, SOME_JUNK2, sizeof(SOME_JUNK2));
        close(fd);
        fd = open("/sys/blah/blah/attribute3", O_RDWR);
        write(fd, SOME_JUNK3, sizeof(SOME_JUNK3));
        close(fd);
        fd = open("/sys/blah/blah/attribute4", O_RDWR);
        write(fd, SOME_JUNK4, sizeof(SOME_JUNK4));
        close(fd);
        fd = open("/sys/blah/blah/attribute5", O_RDWR);
        write(fd, SOME_JUNK5, sizeof(SOME_JUNK5));
        close(fd);
        fd = open("/sys/blah/blah/attribute6", O_RDWR);
        write(fd, SOME_JUNK6, sizeof(SOME_JUNK6));
        close(fd);
        fd = open("/sys/blah/blah/attribute7", O_RDWR);
        write(fd, SOME_JUNK7, sizeof(SOME_JUNK7));
        close(fd);

        /* When the attribute write_doorbell is written to, by
convention
           of this particular device "/sys/blah/blah",  it acts as a
           doorbell which causes all the values which were "latched" by
           the above writes to be consolidated into one command and
           written to the hardware.  */

        fd = open("/sys/blah/blah/write_doorbell", O_RDWR);
        write(fd, "ding dong", 9);
        close(fd);

        release_some_kind_of_semaphore();

I'm not suggesting that the above is a good idea.  I don't have a good
idea about how to do this.
