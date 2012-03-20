From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result
	correctly when SRB status is INVALID
Date: Tue, 20 Mar 2012 14:42:26 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B76A3D3@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1332115915-26805-1-git-send-email-kys@microsoft.com>
	<1332115963-26855-1-git-send-email-kys@microsoft.com>
	<1332173560.3152.65.camel@dabdike>
	<6E21E5352C11B742B20C142EB499E0481B769E88@TK5EX14MBXC126.redmond.corp.microsoft.com>
	<1332196819.3152.77.camel@dabdike>
	<6E21E5352C11B742B20C142EB499E0481B76A16D@TK5EX14MBXC126.redmond.corp.microsoft.com>
	<1332233502.14019.14.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1332233502.14019.14.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: devel-bounces@linuxdriverproject.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ohering@suse.com" <ohering@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Tuesday, March 20, 2012 4:52 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result correctly
> when SRB status is INVALID
> 
> On Mon, 2012-03-19 at 22:52 +0000, KY Srinivasan wrote:
> > > >  However, keep in mind
> > > > that there is no current ETA on when Windows will ship with these changes
> -
> > > Windows 8
> > > > may ship with code where they would return an invalid SRB status, but they
> are
> > > not
> > > > setting the sense code, hence this patch. When the Window host does the
> > > "right thing"
> > > > I will clean this up, but I don't know when that will be.
> > >
> > > I thought you just said you'd only just asked them if they could
> > > implemented it, in which case no version of windows currently ships with
> > > this, correct?
> >
> > There are some private builds of windows 8 floating around with this change,
> where
> > they are returning ILLEGAL_REQUEST SRB status  without any sense data.
> 
> Sure, but they're not shipped, right ... it's like the test builds we do
> for large companies like IBM and HP to try out certain things before
> deciding they don't work.

They are close to shipping and it is very difficult to get any changes in
presently. Furthermore, this is only on windows8; none of the prior 
versions of windows servers of interest support this. I am starting an effort to
get this change into prior windows servers. Once again, it is not clear when
these changes will be pushed out.

  
> 
> > > > More importantly, the second patch  in this series where I filter out
> > > > the ATA_16 command
> > > > on the guest is really important for us. Without that patch on a range
> > > > on windows hosts
> > > > including the current beta version of windows8 where the host is
> > > > returning a generic
> > > > error in response to ATA_16 command, we cannot boot many Linux
> > > > distros. If you
> > > > prefer, I can drop the first patch and re-submit the second patch for
> > > > consideration now.
> > >
> > > I'm not sure about that either.  You presumably translate
> > > SRB_STATUS_ERROR into DID_TARGET_FAILURE.  That should cause the
> > > termination of the command with prejudice in exactly the same way as an
> > > ILLEGAL_REQUEST sense code would (minus the useful error information),
> > > so what's causing the boot failure?
> >
> > You are right, currently without a proper SRB code, I do a DID_TARGET_FAILURE
> and
> > this results in the device being offlined and if the device happens to be the root
> device,
> > we obviously cannot boot. I have seen this problem with sles11 sp2 on a win8
> box.
> 
> OK, so this may be the root cause of the problem.  DID_TARGET_FAILURE
> returns FAILED from scsi_decide_disposition().  This wakes up the error
> handler to retry the command and, since the command is never going to
> work, this ends up offlining the device.  The same thing will happen for
> every command with no recovery.
> 
> The question now is, what else returns SRB_STATUS_ERROR?  If it's always
> for stuff that's unretryable, then the DID_ error is wrong and you
> should be returning DID_PASSTHROUGH with an error code and the problem
> will be solved.  If we can get SRB_STATUS_ERROR on retryable commands,
> then you discriminate at the point of failure, not at the point of input
> and return DID_TARGET_FAILURE for the ones that should be retried and
> DID_PASSTHROUGH + error for the ones that shouldn't.  This will ensure
> the driver is completely backwards compatible and that it will work
> if/when windows properly handles the commands.

James, unfortunately based on the current SRB codes I get back from the
host, I don't know which commands that failed ought to be retried and which
ones should not be; I simply get a single SRB error code for cases where the 
host filtered the unsupported commands as well as the case where the host 
supported the command and something failed in the command execution.
If there is something I can try in this driver to fix this problem, I am more than
happy to try it. If it involves getting changes into  the host (win8, win2k8 etc.),
I am willing to start a conversation with the relevant teams, but I cannot 
obviously determine when such changes will ship. However, I do need
solution for the problem now.

I appreciate your taking the time to help me gravitate towards the 
correct solution here. Given my constraints, let me know what is the
best way forward here.

Regards,

K. Y   
