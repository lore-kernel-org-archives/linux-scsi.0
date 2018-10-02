From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Tue, 02 Oct 2018 16:06:31 -0700
Message-ID: <1538521591.193396.8.camel@acm.org>
References: <20180930205448.26205-1-natechancellor@gmail.com>
         <10b12992-3570-4646-374b-82cbd7276839@acm.org>
         <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
         <1538503063.193396.6.camel@acm.org>
         <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-10-02 at 15:33 -0700, Nick Desaulniers wrote:
+AD4 On Tue, Oct 2, 2018 at 10:57 AM Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4 wrote:
+AD4 +AD4 Explicitly initialized global and static variables end up in the .data
+AD4 +AD4 section and need space in that section.
+AD4 
+AD4 Unless the initial value is zero.
+AD4 https://godbolt.org/z/curRoO
+AD4 
+AD4 So you don't wind up with an increase in binary size simply by having
+AD4 global variables initialized to zero, right?  Instead the kernel knows
+AD4 to create a zero'd out mapping for bss.  You don't need a run of zeros
+AD4 in the binary.
+AD4 
+AD4 So I disagree when you said earlier +ACI-zero initializers should be left
+AD4 out to minimize the size of object files.+ACI I assert they don't affect
+AD4 the size of the binary.
+AD4 
+AD4 If you had many global variables all initialized to zero, why would
+AD4 you encode that many zeros in a binary, when you can just set a size
+AD4 on the bss section and have the kernel create the appropriate sized
+AD4 and zero'd mapping?
+AD4 
+AD4 +AD4 That is not the case if the
+AD4 +AD4 initializer is left out and these variables end up in the .bss section.
+AD4 
+AD4 From my above link, gcc will put globals without initializers into +ACI-common.+ACI

No matter what particular compiler versions do with explicit initialization
to zero, the preferred kernel coding style is to leave out such explicit
initialization.

Bart.
