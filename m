From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 22:08:35 +0100
Message-ID: <c94ce566-c788-7dc2-4b76-a57fd78aaec8@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org> <20181111134241.GA2447@thunk.org>
 <20181112082013.GA9307@infradead.org>
 <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
 <20181116093225.GA17033@infradead.org>
 <fa3ed175-13a3-bedf-ebf9-ddf46a2decd5@redhat.com>
 <20181116174352.GH20617@thunk.org> <1542392239.100259.52.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542392239.100259.52.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 16/11/18 19:17, Bart Van Assche wrote:
> On Fri, 2018-11-16 at 12:43 -0500, Theodore Y. Ts'o wrote:
>> I'd argue that a purpose-built eBPF access control facility is
>> superior to the security_file_ioctl() LSM hook because it can make
>> available to the authorization function access to the cached results
>> of the SCSI INQUIRY command, and it avoids needing to duplicate
>> knowledge of how to parse the parameters of the SG_IO ioctl in the LSM
>> module as well as in the SCSI stack.
> 
> If an eBPF program would decide which SG_IO commands will be executed
> and which ones not, does that mean that a SCSI parser would have to be
> implemented in eBPF? If so, does that mean that both the eBPF and the
> LSM approach share the disadvantage of requiring to do SCSI CDB parsing
> outside the SCSI core?

The LSM approach cannot do SCSI CDB parsing, unless you add a special
SCSI-specific hook called after parsing the SG_IO argument, due to race
conditions.  I'd rather not do that, however it would have that
disadvantage indeed.

The eBPF approach pushes the policy and the parsing entirely to
userspace, so I'm not sure you can say it's a disadvantage.  It's just a
different design.  If you use SG_IO you're already in for writing
userspace code that handles CDBs, sense data etc.

Paolo
