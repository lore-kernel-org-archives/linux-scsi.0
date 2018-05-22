From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/6] block: Consolidate scsi sense buffer usage
Date: Tue, 22 May 2018 11:15:06 -0700
Message-ID: <20180522181512.39316-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a follow-up to commit f7068114d45e ("sr: pass down correctly
sized SCSI sense buffer") which further cleans up and removes needless
sense character array buffers and "struct request_sense" usage in favor
of the common "struct scsi_sense_hdr".

First, drop a bunch of unused sense buffers:
 [PATCH 1/6] ide-cd: Drop unused sense buffers
 [PATCH 2/6] scsi: cxlflash: Drop unused sense buffers

Next, split out struct scsi_sense_hdr:
 [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI

Then move all request_sense usage to scsi_sense_hdr:
 [PATCH 4/6] block: Consolidate scsi sense buffer usage

Finally add a build-time check to make sure we don't pass bad buffer sizes:
 [PATCH 5/6] libata-scsi: Move sense buffers onto stack
 [PATCH 6/6] scsi: Check sense buffer size at build time

-Kees
