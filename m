From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: SCSI layer retries even when medium is not present
Date: Fri, 21 Mar 2003 17:11:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321161149.GA9464@win.tue.nl>
References: <Pine.LNX.4.44L0.0303211004050.806-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0303211004050.806-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, Mar 21, 2003 at 10:08:02AM -0500, Alan Stern wrote:

> Can anybody explain why the SCSI layer issues READ-CAPACITY three times in
> a row (for an emulated direct-access drive) when each time the sense code
> indicates the medium is not present?
> 
> Wouldn't just once be enough?

For 2.5 I did something like

void sd_read_capacity(...) {
	int retries = 3;

	do {
		cmd[0] = READ_CAPACITY;
		scsi_wait_req(...);
		if (media_not_present(...)
			return;
	} while (--retries);
}

I tried to give Marcelo some very small sd patch, an obvious
improvement, but failed. So, I have given up on 2.4. Maybe
others can try to make corresponding improvements to 2.4.

Andries

