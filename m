From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDD reentrancy
Date: Mon, 26 Aug 2002 14:00:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208261900.g7QJ0r501788@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA11745
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 12:01:00 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Mon, 26 Aug 2002 10:27:46 PDT." <20020826172746.GA1301@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Aron Zeh <ARZEH@de.ibm.com>, Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>

andmike@us.ibm.com said:
> James I do not follow the usage of LUNs linked by pointers, can you
> explain further? 

Yes:  the mid-layer could function only with Scsi_Devices and Scsi_Hosts.  
LUNs are currently only used explicitly for scanning.  However, I'd like to 
make the error handler handle the consequences of its action, thus it will 
need to know LUN relationships to handle a BDR correctly.  However, the mid 
layer doesn't need an arbitrary number associated with LUN or PUN.  Since the 
number, string or whatever is only really useful to the lld.  So, simply put, 
we'd probably have an entry in the Scsi_Device for lun_list.  This would be 
the usual doubly linked list so starting with any Scsi_Device we could always 
find the associated LUNs.

James


