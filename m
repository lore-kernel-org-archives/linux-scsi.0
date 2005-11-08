From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: oops with USB Storage on 2.6.14
Date: Tue, 08 Nov 2005 16:45:54 -0500
Message-ID: <1131486354.3270.42.camel@mulgrave>
References: <C2EEB4E538D3DC48BF57F391F422779321ADC0@srmanning.eng.emc.com>
	 <1131484123.3270.36.camel@mulgrave>  <20051108213306.GA25219@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965037AbVKHVrP@vger.kernel.org>
In-Reply-To: <20051108213306.GA25219@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "goggin, edward" <egoggin@emc.com>, 'Rolf Eike Beer' <eike-kernel@sf-tec.de>, 'Andrew Morton' <akpm@osdl.org>, Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2005-11-08 at 13:33 -0800, Patrick Mansfield wrote:
> I mean we get a ref to the sdev in the upper level driver opens, scan, and
> sd flush. So where are we not getting a ref? 
> 
> Shouldn't the get be done at a higher level?

Actually, no, because of the way we run the queues for the next command.

If this is a sd_sync_cache() or something for the last possible command
on the device, the process may have a reference to the device, but as
soon as we call end_that_request_last(), they may be racing to release
it.  The bug is triggered when we get into scsi_next_command() with us
holding the only remaining reference to the device.

James
