From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Wed, 22 May 2002 18:53:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020522185349.D2819@redhat.com>
References: <200205212311.g4LNBYo09061@localhost.localdomain> <20020522154406.A17222@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020522154406.A17222@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Wed, May 22, 2002 at 03:44:06PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, May 22, 2002 at 03:44:06PM -0700, Patrick Mansfield wrote:
> Do you think the queue depth on some of the adapters/devices should be
> shrunk or the request queue increased with your patch? Some adapters set

Actually, more appropriate for future versions would be to make the queue
depth adjustable.  Justin's aic driver sets the depth to 253 because he
can't increase it later if he wants to, but he can queue things up
internally if he ever needs to decrease it.  If low level drivers had some
way of signalling up the stack "hey, this is how many queue slots I can
handle on this particular device now" at their leisure, then that would be
a far superior option to what we have now which is the mid layer saying to
the low level drivers "OK, tell me how many commands you can support on
this list of devices and you have to stick with that until the next
reboot".  So, instead of the mid layer calling into the low level driver 
to tell it to set queue depths, I think the low level driver should be 
allowed to call into the mid layer and have the mid layer adjust the queue 
depth on a device.  This should, of course, be properly locked so that a 
low level driver can change it's mind about a device's queue depth later 
if it wishes and call back into the mid layer with a new queue depth 
value without confusing the mid layer.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
