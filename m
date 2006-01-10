From: "John Treubig" <jtreubig@hotmail.com>
Subject: Error handling in LibATA
Date: Tue, 10 Jan 2006 16:30:35 -0600
Message-ID: <BAY101-F102837A76FADACF6F37DBBDF250@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I've been working on a problem with Promise 20269 PATA adapter under LibATA 
that if the drive has a write error or time-out, the application that is 
accessing the drive using SG should see some sort of error.  My first 
problem was my system hung.  After patching the IDE-IO.C, with a recognized 
patch, I have been able to keep my system from hanging.  Now the only 
problem is the application gets no notification that the drive has been 
rendered inaccessible.  (Test case is to run a system with my app going, and 
then pull the power from the drive.  System log shows the errors, but 
nothing gets back to the app).  The app does get notifications if I perform 
the same type of test on a drive attached to the motherboard secondary IDE 
adapter, so we know the app is correctly implemented.

I've traced the errors down to the fact that the errors are caught in 
libata-core.c (ata_qc_timeout).  I'd like to put a call in libata-core.c 
that would cause an error to be reflected back to the application.  Can you 
suggest the function or method that would do this?

Best wishes,
John Treubig
VT Miltope Corporation


