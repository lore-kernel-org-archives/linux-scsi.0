From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 16:18:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204082020.QAA06773@hancock.sc.steeleye.com>
References: <20020408091844.L7333@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: (from root@localhost)
	by hancock.sc.steeleye.com (8.9.3/8.9.3) id QAA06957
	for <linux-scsi@vger.kernel.org>; Mon, 8 Apr 2002 16:20:31 -0400
In-Reply-To: <20020408091844.L7333@austin.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: sullivan@austin.ibm.com, linux-scsi@vger.kernel.org

On Monday 08 April 2002 11:18 am, sullivan wrote:
> I have been working on a prototype to allow the persistent naming of scsi
> devices across boots. The prototype attempts to address the namespace
> slippage that occurs when names are assigned based on discovery order or
> topology, and a hardware configuration change occurs. It does this by
> assigning names based on the characteristics of the device.
>
> The prototype and more detailed info can be found at:
> http://oss.software.ibm.com/devreg/


Looks good.  As your README acknowledges one problem is that not all devices 
support the pages 0x80 and 0x83.

A quick scan of the code looks like you will work well with the "good" 
devices.  :-)

Several cases you might want to consider for "bad" devices:
- devices that don't support 0x00 and return standard inquiry data instead!
- devices that don't support 0x00 but do support 0x80

For the first case you can snoop the return data from 0x00 to see if it looks 
"good" versus looks like standard inquiry.

For the second case if 0x00 fails go ahead and try 0x80 anyway.

Eddie



