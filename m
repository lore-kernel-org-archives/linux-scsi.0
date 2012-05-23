From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v3 1/4] block: add a flag to identify PM request
Date: Wed, 23 May 2012 23:35:56 +0800
Message-ID: <CAF1ivSbVHUgauQHBRm9Cyo_Fm3gQ0W+R_fQ6gQHAY6B=Q4WsRQ@mail.gmail.com>
References: <1337671292-15583-2-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205231058400.1566-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205231058400.1566-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2012 at 11:02 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> Add a flag REQ_PM to identify the request is PM related.
>> As an example, modify scsi code to use this flag.
>
> Don't forget to check up on the SCSI error handler. =A0If I'm not
> mistaken, the libata drivers use it during suspend and resume. =A0Als=
o,

You are right.

ata_port_suspend_common
  ata_port_request_pm
    ata_port_schedule_eh
      scsi_schedule_eh
        scsi_error_handler ---> libata error handler

I just have a quick look and it seems libata error handler does not
send SCSI request.
Will check more.

> the error handler will run if one of the REQ_PM commands encounters a=
n
> error.
>
> Therefore it seems likely that every request submitted by the error
> handler needs to have REQ_PM set.
>
> Alan Stern
