From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] scsi: mpt3sas: Added support for nvme encapsulated
 request message.
Date: Wed, 8 Nov 2017 11:07:15 +0300
Message-ID: <20171108080715.rn4c6ujlx5kuy46g@mwanda>
References: <20171107113330.airlabvvr3l7oku6@mwanda>
 <258eaa60cc970201a449e079c37a2dbb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21650 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdKHIH2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 03:07:28 -0500
Content-Disposition: inline
In-Reply-To: <258eaa60cc970201a449e079c37a2dbb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org

On Tue, Nov 07, 2017 at 10:29:20AM -0700, Sathya Prakash Veerichetty wrote:
> Dan,
> The MPI structures are of variable length and can go up to a maximum of
> 128 bytes (a MPI frame size) and as MPI standard the variable length MPI
> structures are left out with the last element as a single dword array.
> Can we ignore the warning?

Yeah.  These are a one time email but eventually other people running
static checkers are going to be confused as well.

> If not we need to modify the MPI structure to
> have the NVMe_Command array to the maximum size of the frame (which is
> typically 128 but can change across hardware generations)

To be honest, to declaring arrays as their maximum size is a pretty
common idiom...

	U8      NVMe_Command[4];                /*0x20 */

What does the 4 *mean* in this context?  As a human being, I would
understand that to be a 4 byte array, but it's clearly not.  You're
saying it's supposed to be a single dword array but why???  Is there
something special and mandatory stored in the first 4 bytes?  Why can't
it just be a zero size array?

It would help if there were at least a comment or something.

regards,
dan carpenter
