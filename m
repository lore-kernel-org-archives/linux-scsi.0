From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Thu, 11 Oct 2012 11:24:29 +0100
Message-ID: <1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36170 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258Ab2JKKYc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2012 06:24:32 -0400
In-Reply-To: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 10:15 +0100, James Hogan wrote:
> The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
> used in struct osd_cdb_head, but it isn't marked as packed. Some
> architectures will round the struct size up which triggers BUILD_BUG_ON
> compile errors in osd_initiator.c when the outer structs are unexpected
> sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.

What actual problem have you encountered? The structure is {u8[8], u16}
which is naturally packed on every architecture I know about.  I've even
built osd_initiator without problem on parisc, which has some of the
most rigid alignment rules I've seen.

James


