From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi_report_lun_scan bug?
Date: Mon, 17 Nov 2003 21:52:52 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031117215252.A25366@beaverton.ibm.com>
References: <20031118024833.7619.qmail@web13006.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031118024833.7619.qmail@web13006.mail.yahoo.com>; from patelamitv@yahoo.com on Mon, Nov 17, 2003 at 06:48:33PM -0800
To: Amit Patel <patelamitv@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 17, 2003 at 06:48:33PM -0800, Amit Patel wrote:
> Hi,
> 
> I am using 2.6-test9-mm3. I noticed while doing
> scsi_report_lun_scan(scsi_scan.c:891) the data
> returned is assigned(scsi_scan.c:993) to signed char
> array which causes the reported number of luns to be
> huge while calculating num_luns to scan. Is there any
> particular reason to be data is signed or just a bug?
> 
> I changed it to unsigned char and it seems to work
> fine. I have attached a diff of scsi_scan.c. Let me
> know if I am missing something.

I don't see why making it signed or unsigned would make any difference.

What values did you see before and after your patch?

It should really be a u8, since it is a pointer to an array of bytes.

(And all the scsi_cmd[]'s should be u8.)

-- Patrick Mansfield
