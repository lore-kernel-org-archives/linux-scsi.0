From: "Wu Zhou" <zhouwu@cn.ibm.com>
Subject: Re: aic7xxx & st - why does sym driver don't like odd count on wide bus?
Date: Wed, 13 Aug 2003 16:03:03 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF92B31A00.CBB60BCB-ON48256D81.002C0A5E@cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausmtp02.au.ibm.com ([202.81.18.187]:51955 "EHLO
	ausmtp02.au.ibm.com") by vger.kernel.org with ESMTP id S271685AbTHMICE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 04:02:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kai.Makisara@kolumbus.fi

Sorry. I forget to add the attachment, it is here:

[root@plinuxt17 root]# dd if=/dev/zero of=/dev/sdf1 bs=1025 count=1
1+0 records in
1+0 records out
[root@plinuxt17 root]# dd if=/dev/sdf1 bs=1025 count=1 of=/tmp/sdf.dat
1+0 records in
1+0 records out
[root@plinuxt17 root]# od -x /tmp/sdf.dat
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0002000 0000
0002001
[root@plinuxt17 root]#

Thanks and Best Regards
---------------------------------------------
Zhou, Wu
Software Engineer, IBM China Development Lab
Email: zhouwu@cn.ibm.com
Notes: Wu Zhou/China/IBM@IBMCN
----- Forwarded by Wu Zhou/China/IBM on 2003-08-13 15:56 -----
                                                                                                                                       
                      Wu Zhou                                                                                                          
                                               To:       linux-scsi@vger.kernel.org                                                    
                      2003-08-13 11:50         cc:       Kai.Makisara@kolumbus.fi                                                      
                                               From:     Wu Zhou/China/IBM@IBMCN                                                       
                                               Subject:  Re: aic7xxx & st - why does sym driver don't like odd count on wide bus?      
                                                                                                                                       
                                                                                                                                       



Hi, Kai

      You ever said that sym driver doesn't like odd counts on wide bus.
What I want to know is why. Is this a defect? I ever try the following
command:

[root@plinuxt17 root]# mt -f /dev/st0 setblk 0
[root@plinuxt17 root]# dd if=/dev/zero of=/dev/st0 bs=1025 count=1
1+0 records in
1+0 records out
dd: closing output file `/dev/st0': Input/output error

and running "dmesg" will show the following message:
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 34, WBS 10, BLL 8
st0: Density 26, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 32768 (1 blocks).
sym53c896-1-<0,0>: extraneous data discarded.
sym53c896-1-<0,0>: COMMAND FAILED (89 0) @c0000002fce6a800.
st0: Error: 27070000, cmd: a 0 0 4 1 0 Len: 1025
st0: Async write error (flush) 27070000.
st0: Rewinding tape.

If it is real that sym driver doesn't like odd counts, then how to explain
the following command return no error(sdf and st0 are on the same sym53c896
adapter). I am quite new to SCSI, and just curious about that.

Thanks and Best Regards
---------------------------------------------
Zhou, Wu
Software Engineer, IBM China Development Lab
Email: zhouwu@cn.ibm.com
Notes: Wu Zhou/China/IBM@IBMCN


