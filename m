From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC][PATCH 1/5 v2] tracing: Add trace_seq_buffer_ptr() helper
 function
Date: Thu, 26 Jun 2014 20:14:15 -0700
Message-ID: <1403838855.7854.1.camel@dabdike>
References: <20140626214901.596791200@goodmis.org>
	 <20140626220129.452783019@goodmis.org>
	 <20140626210603.3f797c0c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52320 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbaF0DOW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 23:14:22 -0400
In-Reply-To: <20140626210603.3f797c0c@gandalf.local.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>, Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org

On Thu, 2014-06-26 at 21:06 -0400, Steven Rostedt wrote:
> As this patch is in my 3.17 queue and it touches the kvm and scsi
> tracepoint code, I figured I should at least do the courtesy of
> notifying the maintainers of those subsystems.
> 
> Do you have any issues with this going through my tree? If not, please
> give me an Acked-by.

Missing cc to linux-scsi added.

Hannes has a set of patches to move logging to trace points.  I don't
think there's a clash but I'd like him to comment before you do this.

James


> Thanks!
> 
> -- Steve
> 
> On Thu, 26 Jun 2014 17:49:02 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > There's several locations in the kernel that open code the calculation
> > of the next location in the trace_seq buffer. This is usually done with
> > 
> >   p->buffer + p->len
> > 
> > Instead of having this open coded, supply a helper function in the
> > header to do it for them. This function is called trace_seq_buffer_ptr().
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  arch/x86/kvm/mmutrace.h     |  2 +-
> >  drivers/scsi/scsi_trace.c   | 16 ++++++++--------
> >  include/linux/trace_seq.h   | 15 +++++++++++++++
> >  kernel/trace/trace_output.c | 14 +++++++-------
> >  4 files changed, 31 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
> > index 9d2e0ffcb190..2e5652b62fd6 100644
> > --- a/arch/x86/kvm/mmutrace.h
> > +++ b/arch/x86/kvm/mmutrace.h
> > @@ -22,7 +22,7 @@
> >  	__entry->unsync = sp->unsync;
> >  
> >  #define KVM_MMU_PAGE_PRINTK() ({				        \
> > -	const char *ret = p->buffer + p->len;				\
> > +	const char *ret = trace_seq_buffer_ptr(p);			\
> >  	static const char *access_str[] = {			        \
> >  		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
> >  	};							        \
> > diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> > index 2bea4f0b684a..503594e5f76d 100644
> > --- a/drivers/scsi/scsi_trace.c
> > +++ b/drivers/scsi/scsi_trace.c
> > @@ -28,7 +28,7 @@ scsi_trace_misc(struct trace_seq *, unsigned char *, int);
> >  static const char *
> >  scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  	sector_t lba = 0, txlen = 0;
> >  
> >  	lba |= ((cdb[1] & 0x1F) << 16);
> > @@ -46,7 +46,7 @@ scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
> >  static const char *
> >  scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  	sector_t lba = 0, txlen = 0;
> >  
> >  	lba |= (cdb[2] << 24);
> > @@ -71,7 +71,7 @@ scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
> >  static const char *
> >  scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  	sector_t lba = 0, txlen = 0;
> >  
> >  	lba |= (cdb[2] << 24);
> > @@ -94,7 +94,7 @@ scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
> >  static const char *
> >  scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  	sector_t lba = 0, txlen = 0;
> >  
> >  	lba |= ((u64)cdb[2] << 56);
> > @@ -125,7 +125,7 @@ scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
> >  static const char *
> >  scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len, *cmd;
> > +	const char *ret = trace_seq_buffer_ptr(p), *cmd;
> >  	sector_t lba = 0, txlen = 0;
> >  	u32 ei_lbrt = 0;
> >  
> > @@ -180,7 +180,7 @@ out:
> >  static const char *
> >  scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  	unsigned int regions = cdb[7] << 8 | cdb[8];
> >  
> >  	trace_seq_printf(p, "regions=%u", (regions - 8) / 16);
> > @@ -192,7 +192,7 @@ scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
> >  static const char *
> >  scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len, *cmd;
> > +	const char *ret = trace_seq_buffer_ptr(p), *cmd;
> >  	sector_t lba = 0;
> >  	u32 alloc_len = 0;
> >  
> > @@ -247,7 +247,7 @@ scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
> >  static const char *
> >  scsi_trace_misc(struct trace_seq *p, unsigned char *cdb, int len)
> >  {
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  
> >  	trace_seq_printf(p, "-");
> >  	trace_seq_putc(p, 0);
> > diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
> > index dd85753e1bb0..ea6c9dea79e3 100644
> > --- a/include/linux/trace_seq.h
> > +++ b/include/linux/trace_seq.h
> > @@ -25,6 +25,21 @@ trace_seq_init(struct trace_seq *s)
> >  	s->full = 0;
> >  }
> >  
> > +/**
> > + * trace_seq_buffer_ptr - return pointer to next location in buffer
> > + * @s: trace sequence descriptor
> > + *
> > + * Returns the pointer to the buffer where the next write to
> > + * the buffer will happen. This is useful to save the location
> > + * that is about to be written to and then return the result
> > + * of that write.
> > + */
> > +static inline unsigned char *
> > +trace_seq_buffer_ptr(struct trace_seq *s)
> > +{
> > +	return s->buffer + s->len;
> > +}
> > +
> >  /*
> >   * Currently only defined when tracing is enabled.
> >   */
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index b8930f79a04b..c6977d5a9b12 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -75,7 +75,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
> >  {
> >  	unsigned long mask;
> >  	const char *str;
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  	int i, first = 1;
> >  
> >  	for (i = 0;  flag_array[i].name && flags; i++) {
> > @@ -111,7 +111,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
> >  			 const struct trace_print_flags *symbol_array)
> >  {
> >  	int i;
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  
> >  	for (i = 0;  symbol_array[i].name; i++) {
> >  
> > @@ -122,7 +122,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
> >  		break;
> >  	}
> >  
> > -	if (ret == (const char *)(p->buffer + p->len))
> > +	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
> >  		trace_seq_printf(p, "0x%lx", val);
> >  		
> >  	trace_seq_putc(p, 0);
> > @@ -137,7 +137,7 @@ ftrace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
> >  			 const struct trace_print_flags_u64 *symbol_array)
> >  {
> >  	int i;
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  
> >  	for (i = 0;  symbol_array[i].name; i++) {
> >  
> > @@ -148,7 +148,7 @@ ftrace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
> >  		break;
> >  	}
> >  
> > -	if (ret == (const char *)(p->buffer + p->len))
> > +	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
> >  		trace_seq_printf(p, "0x%llx", val);
> >  
> >  	trace_seq_putc(p, 0);
> > @@ -162,7 +162,7 @@ const char *
> >  ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
> >  			 unsigned int bitmask_size)
> >  {
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  
> >  	trace_seq_bitmask(p, bitmask_ptr, bitmask_size * 8);
> >  	trace_seq_putc(p, 0);
> > @@ -175,7 +175,7 @@ const char *
> >  ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
> >  {
> >  	int i;
> > -	const char *ret = p->buffer + p->len;
> > +	const char *ret = trace_seq_buffer_ptr(p);
> >  
> >  	for (i = 0; i < buf_len; i++)
> >  		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);



