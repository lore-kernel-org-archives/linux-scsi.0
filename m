From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] add transfer request length?
Date: Thu, 30 May 2002 11:08:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020530110835.A16069@eng2.beaverton.ibm.com>
References: <20020529230047.D26782@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e21.nc.us.ibm.com (8.12.2/8.12.2) with ESMTP id g4UI8bFD145870
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2002 14:08:37 -0400
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by westrelay03.boulder.ibm.com (8.11.1m3/NCO/VER6.1) with ESMTP id g4UI8ar151732
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2002 12:08:36 -0600
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id g4UI92914170
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2002 11:09:02 -0700
In-Reply-To: <20020529230047.D26782@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Wed, May 29, 2002 at 11:00:48PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

On Wed, May 29, 2002 at 11:00:48PM -0700, Matthew Dharm wrote:

> Right now, a low-level SCSI driver (i.e. HBA) can't actually tell in
> advance how much data will be moved by a command.  The driver can see the
> buffer and the buffer length, and can enforce that the transfer length does
> not exceed that buffer length, but we can't actually algorithmically
> determine the amount of data we expect to move....
> 
> For example, imagine an INQUIRY for 36 bytes issued with a buffer for 256
> bytes.  This actually does happen.

You mean the mid-layer asks for 256 bytes (buffer length and cmd are
256), but the device returns less than 256 bytes? If so, I don't see
how setting another field helps.

Or, the mid-layer asks for 36, and buffer length is 256? If so, we should
change the code.

-- Patrick Mansfield
