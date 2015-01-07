From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [LSF/MM ATTEND] iSCSI/iSER MQ + EXTENDED_COPY host support
Date: Wed, 07 Jan 2015 17:11:21 -0500
Message-ID: <54ADAF09.8050405@interlog.com>
References: <1420665695.12144.62.camel@haakon3.risingtidesystems.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420665695.12144.62.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 15-01-07 04:21 PM, Nicholas A. Bellinger wrote:
> Hi LSF-PC folks,
>
> I'd like to attend LSF/MM 2015 this year in Boston.
>
> The topics I'm interested in are iSCSI/iSER multi-queue (MC/S) support
> within the open-iscsi initiator, and pushing forward the pieces
> necessary for EXTENDED_COPY host side support so we can finally begin to
> utilize copy-offload in KVM and Xen environments.
>
> As maintainer of the SCSI target subsystem, I've contributed MC/S
> support in iscsi-target, as well as EXTENDED_COPY(LID1) support within
> the upstream LIO target.  Now that we've got upstream target support for
> these features, I'd like to help facilitate support for these into the
> initiator / host side stack.

T10 have now dropped the LID1 and LID4 stuff (its the length
of the LIST IDENTIFIER field: 1 byte or 4 bytes) by obsoleting
all LID1 variants in SPC-5 revision 01. So the LID1 variants
are now gone and the LID4 appendage is dropped from the remaining
commands.

Obviously LID1 based XCOPY support is important for backward
compatibility (back to SPC-2) but for the future maybe you might
consider adding the equivalent LID4 support for a basic XCOPY.
For example it means using the 3PC VPD page instead of the
RECEIVE COPY RESULTS(operating parameters) command. I believe
FreeNAS now supports both LID1 and LID4 variants of a basic
XCOPY (plus a restricted version of ODX without snapshots).


Doug Gilbert
