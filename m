From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v3 1/4] block: add a flag to identify PM request
Date: Wed, 23 May 2012 11:02:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205231058400.1566-100000@iolanthe.rowland.org>
References: <1337671292-15583-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337671292-15583-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> Add a flag REQ_PM to identify the request is PM related.
> As an example, modify scsi code to use this flag.

Don't forget to check up on the SCSI error handler.  If I'm not
mistaken, the libata drivers use it during suspend and resume.  Also,
the error handler will run if one of the REQ_PM commands encounters an
error.

Therefore it seems likely that every request submitted by the error 
handler needs to have REQ_PM set.

Alan Stern
