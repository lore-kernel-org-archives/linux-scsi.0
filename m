From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [RFC] scsi_normalize_sense()
Date: Tue, 24 Aug 2004 23:15:59 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408242246270.5461@kai.makisara.local>
References: <41258F6A.6030606@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:55386 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S268265AbUHXUQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 16:16:01 -0400
In-Reply-To: <41258F6A.6030606@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 20 Aug 2004, Douglas Gilbert wrote:

> Looking around the linux SCSI subsystem the handling
> of data in the sense buffer is haphazard. Most places
> ignore "deferred" errors (e.g. medium error reported
> later when write caching is on) and will break horribly
> if they every see the newer "descriptor" format.
> 
...
> Here is some code which I am proposing to put into
> scsi_lib.c to facilitate cleaner handling. I have been
> testing it out in sg3_utils-1.08 (beta) for the last
> week.  Comments??
> 
Looks good, especially after some thinking :-) (The extra fields byte? and 
additional_length looked useless until I thought a little further into the 
future.)

In addition to using this basic data, the drivers have to parse the 
descriptors. Parsing the descriptors is device-specific but a library 
function to find a descriptor of certain type might be useful. The 
prototype could be something like this:

/* Returns a pointer to the descriptor of type desc_type in descriptor 
   format sense data or NULL if the descriptor is not found. */
unsigned char *scsi_sense_descriptor(const unsigned char *sensep,
                                     int sb_len, int desc_type)

-- 
Kai
