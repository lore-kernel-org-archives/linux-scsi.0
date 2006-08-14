From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] Sanitize INQUIRY vendor, product and revision strings
Date: Mon, 14 Aug 2006 20:48:41 +0200
Message-ID: <44E0C589.5080602@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0608141221520.7399-100000@iolanthe.rowland.org> <20060814170730.GE4340@parisc-linux.org> <20060814173709.GJ32218@vienna.egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1218 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1752053AbWHNSuB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 14:50:01 -0400
In-Reply-To: <20060814173709.GJ32218@vienna.egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Klaus Muth <muth@hagos.de>

>> On Mon, Aug 14, 2006 at 12:34:56PM -0400, Alan Stern wrote:
>>> Does anyone object to the patch below?  It would help at least one person; 
>>> I'm concerned that it might cause trouble somewhere else.
>>> @@ -526,6 +519,12 @@ static int scsi_probe_lun(struct scsi_de
>>>  		if (response_len > 255)
>>>  			response_len = first_inquiry_len;	/* sanity */
>>>  
>>> +		/* Sanitize the Vendor, Product, and Revision fields. */
>>> +		for (i = 8; i < 36; ++i) {
>>> +			if (inq_result[i] < 0x20 || inq_result[i] > 0x7e)
>>> +				inq_result[i] = ' ';
>>> +		}
>>> +
>>>  		/*

This does affect all subsequent usage of the inquiry data, doesn't it? I.e.
  - comparison against blacklist entries for device flags,
  - readout in dmesg,
  - contents of sysfs attributes,
  - text in procfs?
-- 
Stefan Richter
-=====-=-==- =--- -===-
http://arcgraph.de/sr/
